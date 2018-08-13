public class FerretLogGeneratorV1
{
    private static final String METHOD_ENTRY_PREFIX = 'VLOCITY_METHOD_ENTRY|';
    private static final String METHOD_EXIT_PREFIX = 'VLOCITY_METHOD_EXIT|';

    private static Integer sequenceNumber = 1;

    public static void logMethodEntry(String className, String methodName)
    {
        String logString = METHOD_ENTRY_PREFIX + className + '.' + methodName + '|S' + String.valueOf(sequenceNumber);

        // it's important we increment only after using the sequence number. client code is fetching the number
        // prior to calling logMethodEntry (it has to be prior - because of scope considerations) and we want that
        // value to match the value logged just here.
        sequenceNumber++;

        System.debug(LoggingLevel.ERROR, logString);
    }

    public static Integer getSequenceNumber()
    {
        return sequenceNumber;
    }

    public static void logMethodExit(String className, String methodName, Integer sequenceNumber)
    {
        String logString = METHOD_EXIT_PREFIX + className + '.' + methodName + '|S' + String.valueOf(sequenceNumber);

        System.debug(LoggingLevel.ERROR, logString);
    }
}