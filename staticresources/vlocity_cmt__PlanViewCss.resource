#canvas {
  width: 100%;
  height: 100%;
  position: relative;
  padding: 20px; }

.dep {
  stroke: #a0aab6;
  stroke-width: 2px;
  fill: none;
  shape-rendering: crispEdges; }

.highlighted {
  stroke: #FB4F03;
  fill: none; }

.swimlane {
  fill: #FFFFFF;
  stroke: #666666;
  stroke-width: 0.5px; }

.item-header.item-completed {
  /*fill: #4bca81;;*/
  fill: rgba(4, 132, 75, 0.95); }

/*
.item-header.item-running {
    fill: #0070d2;
}*/
.item-header.item-failed, .item-header.item-fatally-failed {
  fill: #D0021B; }

/*
.item-header.item-pending {
    fill: #e0e5ee;
}*/
.item-header.item-skipped {
  fill: #a0aab6; }

.item-header.item-cancelled {
  fill: #a0aab6; }

.item-body-text {
  position: absolute;
  color: #0054A3; }
  .item-body-text span {
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
    font-size: 12px;
    display: block; }
    .item-body-text span a, .item-body-text span a:focus {
      color: #0054A3;
      text-decoration: none; }
    .item-body-text span a:hover {
      color: #0054A3; }

.item {
  fill: rgba(237, 237, 237, 0.29);
  stroke: #a0aab6;
  stroke-width: 1px;
  border-radius: 8px; }

.item-label-container {
  position: absolute;
  font-size: 14px;
  display: table; }

.item-label-container.item-header.item-completed {
  min-width: 40px; }

a.item-label, a.item-label:hover, a.item-label:focus {
  display: inline-block;
  vertical-align: middle;
  color: white !important;
  text-decoration: none;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden; }

.item-label:visited {
  color: white;
  text-decoration: none; }

.item-label:hover {
  color: white;
  text-decoration: none; }

.item-label:active {
  color: white;
  text-decoration: none; }

.order-label, .order-label-container div a {
  text-align: left;
  text-transform: uppercase; }

.order-label-container {
  position: absolute;
  font-size: 14px;
  display: block;
  text-overflow: ellipsis;
  overflow: hidden;
  white-space: nowrap;
  max-width: 200px; }

.order-label, .plan-label {
  vertical-align: middle;
  text-align: center;
  overflow: hidden;
  text-overflow: ellipsis;
  font-weight: bold;
  color: black;
  text-decoration: none; }

.order-label:visited, .plan-label:visited {
  color: #005fb2;
  text-decoration: none; }

.order-label:hover, .plan-label:hover {
  color: black;
  text-decoration: none; }

.order-label:active, .plan-label:active {
  color: black;
  text-decoration: none; }

.btn-container {
  position: absolute;
  z-index: 1000;
  top: 3.5%;
  left: .1%; }

#zoomIn {
  margin-top: 3%;
  margin-left: 3%;
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
  border-bottom: none; }

#zoomOut {
  margin-top: 0;
  margin-left: 3%;
  border-top-left-radius: 0;
  border-top-right-radius: 0; }

.vlocity .btn:focus {
  outline: none; }

.item-header.item-pending {
  fill: #e0e5ee; }

.item-header.item-on-hold {
  fill: #f0f2f7; }

a.item-label.item-header.item-pending, a.item-label.item-header.item-pending:hover, a.item-label.item-header.item-pending:focus, a.item-label.item-header.item-pending:visited, a.item-label.item-header.item-on-hold, a.item-label.item-header.item-on-hold:hover, a.item-label.item-header.item-on-hold:focus, a.item-label.item-header.item-on-hold:visited {
  color: #16325c !important; }

.item-header.item-ready, .item-header.item-running, .item-header.item-started {
  fill: #0070d2; }

.item-label.item-pending, item-label.item-on-hold {
  color: #16325c !important; }
