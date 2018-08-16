
(function ($) {
  
  var barcode = {
    settings:{
      barWidth: 1,
      barHeight: 50,
      moduleSize: 5,
      showHRI: true,
      addQuietZone: true,
      marginHRI: 5,
      bgColor: "#FFFFFF",
      color: "#000000",
      fontSize: 10,
      output: "css",
      posX: 0,
      posY: 0
    },
    intval: function(val){
      var type = typeof( val );
      if (type == 'string'){
        val = val.replace(/[^0-9-.]/g, "");
        val = parseInt(val * 1, 10);
        return isNaN(val) || !isFinite(val) ? 0 : val;
      }
      return type == 'number' && isFinite(val) ? Math.floor(val) : 0;
    },
    i25: { // std25 int25
      encoding: ["NNWWN", "WNNNW", "NWNNW", "WWNNN", "NNWNW", "WNWNN", "NWWNN", "NNNWW", "WNNWN","NWNWN"],
      compute: function(code, crc, type){
        if (! crc) {
          if (code.length % 2 != 0) code = '0' + code;
        } else {
          if ( (type == "int25") && (code.length % 2 == 0) ) code = '0' + code;
          var odd = true, v, sum = 0;
          for(var i=code.length-1; i>-1; i--){
            v = barcode.intval(code.charAt(i));
            if (isNaN(v)) return("");
            sum += odd ? 3 * v : v;
            odd = ! odd;
          }
          code += ((10 - sum % 10) % 10).toString();
        }
        return(code);
      },
      getDigit: function(code, crc, type){
        code = this.compute(code, crc, type);
        if (code == "") return("");
        result = "";
        
        var i, j;
        if (type == "int25") {
          // Interleaved 2 of 5
          
          // start
          result += "1010";
          
          // digits + CRC
          var c1, c2;
          for(i=0; i<code.length / 2; i++){
            c1 = code.charAt(2*i);
            c2 = code.charAt(2*i+1);
            for(j=0; j<5; j++){
              result += '1';
              if (this.encoding[c1].charAt(j) == 'W') result += '1';
              result += '0';
              if (this.encoding[c2].charAt(j) == 'W') result += '0';
            }
          }
          // stop
          result += "1101";
        } else if (type == "std25") {
          // Standard 2 of 5 is a numeric-only barcode that has been in use a long time. 
          // Unlike Interleaved 2 of 5, all of the information is encoded in the bars; the spaces are fixed width and are used only to separate the bars.
          // The code is self-checking and does not include a checksum.
          
          // start
          result += "11011010";
          
          // digits + CRC
          var c;
          for(i=0; i<code.length; i++){
            c = code.charAt(i);
            for(j=0; j<5; j++){
              result += '1';
              if (this.encoding[c].charAt(j) == 'W') result += "11";
              result += '0';
            }
          }
          // stop
          result += "11010110";
        }
        return(result);
      }
    },
    ean: {
      encoding: [ ["0001101", "0100111", "1110010"],
                  ["0011001", "0110011", "1100110"], 
                  ["0010011", "0011011", "1101100"],
                  ["0111101", "0100001", "1000010"], 
                  ["0100011", "0011101", "1011100"], 
                  ["0110001", "0111001", "1001110"],
                  ["0101111", "0000101", "1010000"],
                  ["0111011", "0010001", "1000100"],
                  ["0110111", "0001001", "1001000"],
                  ["0001011", "0010111", "1110100"] ],
      first:  ["000000","001011","001101","001110","010011","011001","011100","010101","010110","011010"],
      getDigit: function(code, type){
        // Check len (12 for ean13, 7 for ean8)
        var len = type == "ean8" ? 7 : 12;
        code = code.substring(0, len);
        if (code.length != len) return("");
        // Check each digit is numeric
        var c;
        for(var i=0; i<code.length; i++){
          c = code.charAt(i);
          if ( (c < '0') || (c > '9') ) return("");
        }
        // get checksum
        code = this.compute(code, type);
        
        // process analyse
        var result = "101"; // start
        
        if (type == "ean8"){
  
          // process left part
          for(var i=0; i<4; i++){
            result += this.encoding[barcode.intval(code.charAt(i))][0];
          }
              
          // center guard bars
          result += "01010";
              
          // process right part
          for(var i=4; i<8; i++){
            result += this.encoding[barcode.intval(code.charAt(i))][2];
          }
              
        } else { // ean13
          // extract first digit and get sequence
          var seq = this.first[ barcode.intval(code.charAt(0)) ];
          
          // process left part
          for(var i=1; i<7; i++){
            result += this.encoding[barcode.intval(code.charAt(i))][ barcode.intval(seq.charAt(i-1)) ];
          }
          
          // center guard bars
          result += "01010";
              
          // process right part
          for(var i=7; i<13; i++){
            result += this.encoding[barcode.intval(code.charAt(i))][ 2 ];
          }
        } // ean13
        
        result += "101"; // stop
        return(result);
      },
      compute: function (code, type){
        var len = type == "ean13" ? 12 : 7;
        code = code.substring(0, len);
        var sum = 0, odd = true;
        for(i=code.length-1; i>-1; i--){
          sum += (odd ? 3 : 1) * barcode.intval(code.charAt(i));
          odd = ! odd;
        }
        return(code + ((10 - sum % 10) % 10).toString());
      }
    },
    upc: {
      getDigit: function(code){
        if (code.length < 12) {
          code = '0' + code;
        }
        return barcode.ean.getDigit(code, 'ean13');
      },
      compute: function (code){
        if (code.length < 12) {
          code = '0' + code;
        }
        return barcode.ean.compute(code, 'ean13').substr(1);
      }
    },
    msi: {
      encoding:["100100100100", "100100100110", "100100110100", "100100110110",
                "100110100100", "100110100110", "100110110100", "100110110110",
                "110100100100", "110100100110"],
      compute: function(code, crc){
        if (typeof(crc) == "object"){
          if (crc.crc1 == "mod10"){
            code = this.computeMod10(code);
          } else if (crc.crc1 == "mod11"){
            code = this.computeMod11(code);
          }
          if (crc.crc2 == "mod10"){
            code = this.computeMod10(code);
          } else if (crc.crc2 == "mod11"){
            code = this.computeMod11(code);
          }
        } else if (typeof(crc) == "boolean"){
          if (crc) code = this.computeMod10(code);
        }
        return(code);
      },
      computeMod10:function(code){
        var i, 
        toPart1 = code.length % 2;
        var n1 = 0, sum = 0;
        for(i=0; i<code.length; i++){
          if (toPart1) {
            n1 = 10 * n1 + barcode.intval(code.charAt(i));
          } else {
            sum += barcode.intval(code.charAt(i));
          }
          toPart1 = ! toPart1;
        }
        var s1 = (2 * n1).toString();
        for(i=0; i<s1.length; i++){
          sum += barcode.intval(s1.charAt(i));
        }
        return(code + ((10 - sum % 10) % 10).toString());
      },
      computeMod11:function(code){
        var sum = 0, weight = 2;
        for(var i=code.length-1; i>=0; i--){
          sum += weight * barcode.intval(code.charAt(i));
          weight = weight == 7 ? 2 : weight + 1;
        }
        return(code + ((11 - sum % 11) % 11).toString());
      },
      getDigit: function(code, crc){
        var table = "0123456789";
        var index = 0;
        var result = "";
        
        code = this.compute(code, false);
        
        // start
        result = "110";
        
        // digits
        for(i=0; i<code.length; i++){
          index = table.indexOf( code.charAt(i) );
          if (index < 0) return("");
          result += this.encoding[ index ];
        }
        
        // stop
        result += "1001";
        
        return(result);
      }
    },
    code11: {
      encoding:[  "101011", "1101011", "1001011", "1100101",
                  "1011011", "1101101", "1001101", "1010011",
                  "1101001", "110101", "101101"],
      getDigit: function(code){
        var table = "0123456789-";
        var i, index, result = "", intercharacter = '0'
        
        // start
        result = "1011001" + intercharacter;
        
        // digits
        for(i=0; i<code.length; i++){
          index = table.indexOf( code.charAt(i) );
          if (index < 0) return("");
          result += this.encoding[ index ] + intercharacter;
        }
        
        // checksum
        var weightC    = 0,
        weightSumC = 0,
        weightK    = 1, // start at 1 because the right-most character is "C" checksum
        weightSumK   = 0;
        for(i=code.length-1; i>=0; i--){
          weightC = weightC == 10 ? 1 : weightC + 1;
          weightK = weightK == 10 ? 1 : weightK + 1;
          
          index = table.indexOf( code.charAt(i) );
          
          weightSumC += weightC * index;
          weightSumK += weightK * index;
        }
        
        var c = weightSumC % 11;
        weightSumK += c;
        var k = weightSumK % 11;
        
        result += this.encoding[c] + intercharacter;
        
        if (code.length >= 10){
          result += this.encoding[k] + intercharacter;
        }
        
        // stop
        result  += "1011001";
        
        return(result);
      }   
    },
    code39: {
      encoding:["101001101101", "110100101011", "101100101011", "110110010101",
                "101001101011", "110100110101", "101100110101", "101001011011",
                "110100101101", "101100101101", "110101001011", "101101001011",
                "110110100101", "101011001011", "110101100101", "101101100101",
                "101010011011", "110101001101", "101101001101", "101011001101",
                "110101010011", "101101010011", "110110101001", "101011010011",
                "110101101001", "101101101001", "101010110011", "110101011001",
                "101101011001", "101011011001", "110010101011", "100110101011",
                "110011010101", "100101101011", "110010110101", "100110110101",
                "100101011011", "110010101101", "100110101101", "100100100101",
                "100100101001", "100101001001", "101001001001", "100101101101"],
      getDigit: function(code){
        var table = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*";
        var i, index, result="", intercharacter='0';
        
        if (code.indexOf('*') >= 0) return("");
        
        // Add Start and Stop charactere : *
        code = ("*" + code + "*").toUpperCase();
        
        for(i=0; i<code.length; i++){
          index = table.indexOf( code.charAt(i) );
          if (index < 0) return("");
          if (i > 0) result += intercharacter;
          result += this.encoding[ index ];
        }
        return(result);
      }
    },
    code93:{
      encoding:["100010100", "101001000", "101000100", "101000010",
                "100101000", "100100100", "100100010", "101010000",
                "100010010", "100001010", "110101000", "110100100",
                "110100010", "110010100", "110010010", "110001010",
                "101101000", "101100100", "101100010", "100110100",
                "100011010", "101011000", "101001100", "101000110",
                "100101100", "100010110", "110110100", "110110010",
                "110101100", "110100110", "110010110", "110011010",
                "101101100", "101100110", "100110110", "100111010",
                "100101110", "111010100", "111010010", "111001010",
                "101101110", "101110110", "110101110", "100100110",
                "111011010", "111010110", "100110010", "101011110"],
      getDigit: function(code, crc){
        var table = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%____*", // _ => ($), (%), (/) et (+)
        c, result = "";
        
        if (code.indexOf('*') >= 0) return("");
        
        code = code.toUpperCase();
        
        // start :  *
        result  += this.encoding[47];
        
        // digits
        for(i=0; i<code.length; i++){
          c = code.charAt(i);
          index = table.indexOf( c );
          if ( (c == '_') || (index < 0) ) return("");
          result += this.encoding[ index ];
        }
        
        // checksum
        if (crc){
          var weightC    = 0,
          weightSumC = 0,
          weightK    = 1, // start at 1 because the right-most character is "C" checksum
          weightSumK   = 0;
          for(i=code.length-1; i>=0; i--){
            weightC = weightC == 20 ? 1 : weightC + 1;
            weightK = weightK == 15 ? 1 : weightK + 1;
            
            index = table.indexOf( code.charAt(i) );
            
            weightSumC += weightC * index;
            weightSumK += weightK * index;
          }
          
          var c = weightSumC % 47;
          weightSumK += c;
          var k = weightSumK % 47;
          
          result += this.encoding[c];
          result += this.encoding[k];
        }
        
        // stop : *
        result  += this.encoding[47];
        
        // Terminaison bar
        result  += '1';
        return(result);
      }
    },
    code128: {
      encoding:["11011001100", "11001101100", "11001100110", "10010011000",
                "10010001100", "10001001100", "10011001000", "10011000100",
                "10001100100", "11001001000", "11001000100", "11000100100",
                "10110011100", "10011011100", "10011001110", "10111001100",
                "10011101100", "10011100110", "11001110010", "11001011100",
                "11001001110", "11011100100", "11001110100", "11101101110",
                "11101001100", "11100101100", "11100100110", "11101100100",
                "11100110100", "11100110010", "11011011000", "11011000110",
                "11000110110", "10100011000", "10001011000", "10001000110",
                "10110001000", "10001101000", "10001100010", "11010001000",
                "11000101000", "11000100010", "10110111000", "10110001110",
                "10001101110", "10111011000", "10111000110", "10001110110",
                "11101110110", "11010001110", "11000101110", "11011101000",
                "11011100010", "11011101110", "11101011000", "11101000110",
                "11100010110", "11101101000", "11101100010", "11100011010",
                "11101111010", "11001000010", "11110001010", "10100110000",
                "10100001100", "10010110000", "10010000110", "10000101100",
                "10000100110", "10110010000", "10110000100", "10011010000",
                "10011000010", "10000110100", "10000110010", "11000010010",
                "11001010000", "11110111010", "11000010100", "10001111010",
                "10100111100", "10010111100", "10010011110", "10111100100",
                "10011110100", "10011110010", "11110100100", "11110010100",
                "11110010010", "11011011110", "11011110110", "11110110110",
                "10101111000", "10100011110", "10001011110", "10111101000",
                "10111100010", "11110101000", "11110100010", "10111011110",
                "10111101110", "11101011110", "11110101110", "11010000100",
                "11010010000", "11010011100", "11000111010"],
      getDigit: function(code){
        var tableB = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
        var result = "";
        var sum = 0;
        var isum = 0;
        var i = 0;
        var j = 0;
        var value = 0;
        
        // check each characters
        for(i=0; i<code.length; i++){
          if (tableB.indexOf(code.charAt(i)) == -1) return("");
        }
        
        // check firsts characters : start with C table only if enought numeric
        var tableCActivated = code.length > 1;
        var c = '';
        for(i=0; i<3 && i<code.length; i++){
        c = code.charAt(i);
          tableCActivated &= c >= '0' && c <= '9';
        }
        
        sum = tableCActivated ? 105 : 104;
        
        // start : [105] : C table or [104] : B table 
        result = this.encoding[ sum ];
        
        i = 0;
        while( i < code.length ){
          if (! tableCActivated){
            j = 0;
            // check next character to activate C table if interresting
            while ( (i + j < code.length) && (code.charAt(i+j) >= '0') && (code.charAt(i+j) <= '9') ) j++;
            
            // 6 min everywhere or 4 mini at the end
            tableCActivated = (j > 5) || ((i + j - 1 == code.length) && (j > 3));
            
            if ( tableCActivated ){
            result += this.encoding[ 99 ]; // C table
            sum += ++isum * 99;
            }
            //         2 min for table C so need table B
          } else if ( (i == code.length) || (code.charAt(i) < '0') || (code.charAt(i) > '9') || (code.charAt(i+1) < '0') || (code.charAt(i+1) > '9') ) {
            tableCActivated = false;
            result += this.encoding[ 100 ]; // B table
            sum += ++isum * 100;
          }
          
          if ( tableCActivated ) {
            value = barcode.intval(code.charAt(i) + code.charAt(i+1)); // Add two characters (numeric)
            i += 2;
          } else {
            value = tableB.indexOf( code.charAt(i) ); // Add one character
            i += 1;
          }
          result  += this.encoding[ value ];
          sum += ++isum * value;
        }
        
        // Add CRC
        result  += this.encoding[ sum % 103 ];
        
        // Stop
        result += this.encoding[106];
        
        // Termination bar
        result += "11";
        
        return(result);
      }
    },
    codabar: {
      encoding:["101010011", "101011001", "101001011", "110010101",
                "101101001", "110101001", "100101011", "100101101",
                "100110101", "110100101", "101001101", "101100101",
                "1101011011", "1101101011", "1101101101", "1011011011",
                "1011001001", "1010010011", "1001001011", "1010011001"],
      getDigit: function(code){
        var table = "0123456789-$:/.+";
        var i, index, result="", intercharacter = '0';
        
        // add start : A->D : arbitrary choose A
        result += this.encoding[16] + intercharacter;
        
        for(i=0; i<code.length; i++){
          index = table.indexOf( code.charAt(i) );
          if (index < 0) return("");
          result += this.encoding[ index ] + intercharacter;
        }
        
        // add stop : A->D : arbitrary choose A
        result += this.encoding[16];
        return(result);
      }
    },
	
    // little endian convertor
    lec:{
      // convert an int
      cInt: function(value, byteCount){
        var le = '';
        for(var i=0; i<byteCount; i++){
          le += String.fromCharCode(value & 0xFF);
          value = value >> 8;
        }
        return le;
      },
      // return a byte string from rgb values 
      cRgb: function(r,g,b){
        return String.fromCharCode(b) + String.fromCharCode(g) + String.fromCharCode(r);
      },
      // return a byte string from a hex string color
      cHexColor: function(hex){
        var v = parseInt('0x' + hex.substr(1));
        var b = v & 0xFF;
        v = v >> 8;
        var g = v & 0xFF;
        var r = v >> 8;
        return(this.cRgb(r,g,b));
      }
    },
    hexToRGB: function(hex){
      var v = parseInt('0x' + hex.substr(1));
      var b = v & 0xFF;
      v = v >> 8;
      var g = v & 0xFF;
      var r = v >> 8;
      return({r:r,g:g,b:b});
    },
    // test if a string is a hexa string color (like #FF0000)
    isHexColor: function (value){
      var r = new RegExp("#[0-91-F]", "gi");
      return  value.match(r);
    },
    // encode data in base64
    base64Encode: function(value) {
      var r = '', c1, c2, c3, b1, b2, b3, b4;
      var k = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
      var i = 0;
      while (i < value.length) {
        c1 = value.charCodeAt(i++);
        c2 = value.charCodeAt(i++);
        c3 = value.charCodeAt(i++);
        b1 = c1 >> 2;
        b2 = ((c1 & 3) << 4) | (c2 >> 4);
        b3 = ((c2 & 15) << 2) | (c3 >> 6);
        b4 = c3 & 63;
        if (isNaN(c2)) b3 = b4 = 64;
        else if (isNaN(c3)) b4 = 64;
        r += k.charAt(b1) + k.charAt(b2) + k.charAt(b3) + k.charAt(b4);
      }
      return r;
    },
    // convert a bit string to an array of array of bit char
    bitStringTo2DArray: function( digit ){
      var d = []; d[0] = [];
      for(var i=0; i<digit.length; i++) d[0][i] = digit.charAt(i);
      return(d);
    },
    // clear jQuery Target
    resize: function($container, w){
      $container
        .css("padding", "0px")
        .css("overflow", "auto")
        .css("width", w + "px")
        .html("");
        return $container;
    },

    // css barcode renderer
    digitToCssRenderer : function($container, settings, digit, hri, mw, mh){
      var lines = digit.length;
      var columns = digit[0].length;
      var content = "";
      var bar0 = "<div style=\"float: left; font-size: 0px; background-color: " + settings.bgColor + "; height: " + mh + "px; width: &Wpx\"></div>";    
      var bar1 = "<div style=\"float: left; font-size: 0px; width:0; border-left: &Wpx solid " + settings.color + "; height: " + mh + "px;\"></div>";
  
      var len, current;
      for(var y=0; y<lines; y++){
        len = 0;
        current = digit[y][0];
        for (var x=0; x<columns; x++){
          if ( current == digit[y][x] ) {
            len++;
          } else {
            content += (current == '0' ? bar0 : bar1).replace("&W", len * mw);
            current = digit[y][x];
            len=1;
          }
        }
        if (len > 0){
          content += (current == '0' ? bar0 : bar1).replace("&W", len * mw);
        }
      }  
      if (settings.showHRI){
        content += "<div style=\"clear:both; width: 100%; background-color: " + settings.bgColor + "; color: " + settings.color + "; text-align: center; font-size: " + settings.fontSize + "px; margin-top: " + settings.marginHRI + "px;\">"+hri+"</div>";
      }
      this.resize($container, mw * columns).html(content);
    },
    // css 1D barcode renderer  
    digitToCss: function($container, settings, digit, hri){
      var w = barcode.intval(settings.barWidth);
      var h = barcode.intval(settings.barHeight);
      this.digitToCssRenderer($container, settings, this.bitStringTo2DArray(digit), hri, w, h);
    },
    // css 2D barcode renderer
    digitToCss2D: function($container, settings, digit, hri){
      var s = barcode.intval(settings.moduleSize);
      this.digitToCssRenderer($container, settings, digit, hri, s, s);
    },
  };
  
  $.fn.extend({
    barcode: function(datas, type, settings) {
      var digit = "",
          hri   = "",
          code  = "",
          crc   = true,
          rect  = false,
          b2d   = false;
      
      if (typeof(datas) == "string"){
        code = datas;
      } else if (typeof(datas) == "object"){
        code = typeof(datas.code) == "string" ? datas.code : "";
        crc = typeof(datas.crc) != "undefined" ? datas.crc : true;
        rect = typeof(datas.rect) != "undefined" ? datas.rect : false;
      }
      if (code == "") return(false);
      
      if (typeof(settings) == "undefined") settings = [];
      for(var name in barcode.settings){
        if (settings[name] == undefined) settings[name] = barcode.settings[name];
      }
      
      switch(type){
        case "std25":
        case "int25":
          digit = barcode.i25.getDigit(code, crc, type);
          hri = barcode.i25.compute(code, crc, type);
        break;
        case "ean8":
        case "ean13":
          digit = barcode.ean.getDigit(code, type);
          hri = barcode.ean.compute(code, type);
        break;
        case "upc":
          digit = barcode.upc.getDigit(code);
          hri = barcode.upc.compute(code);
        break;
        case "code11":
          digit = barcode.code11.getDigit(code);
          hri = code;
        break;
        case "code39":
          digit = barcode.code39.getDigit(code);
          hri = code;
        break;
        case "code93":
          digit = barcode.code93.getDigit(code, crc);
          hri = code;
        break;
        case "code128":
          digit = barcode.code128.getDigit(code);
          hri = code;
        break;
        case "codabar":
          digit = barcode.codabar.getDigit(code);
          hri = code;
        break;
        case "msi":
          digit = barcode.msi.getDigit(code, crc);
          hri = barcode.msi.compute(code, crc);
        break;

      }
      if (digit.length == 0) return($(this));
      
      // Quiet Zone
      if ( !b2d && settings.addQuietZone) digit = "0000000000" + digit + "0000000000";
      
      var $this = $(this);
      var fname = 'digitTo' + settings.output.charAt(0).toUpperCase() + settings.output.substr(1) + (b2d ? '2D' : '');
      if (typeof(barcode[fname]) == 'function') {
        barcode[fname]($this, settings, digit, hri);
      }
      
      return($this);
    }
  });

}(jQuery));