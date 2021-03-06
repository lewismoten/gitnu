import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';

import '../app/stringutils.dart';

/**
 * Setup the tests.
 * TODO (camfitz): Centralise the test runner for multiple test classes.
 */
void main() {
  useVMConfiguration();
  StringUtilsTest.run();
}

/**
 * Tests for the StaticToolkit class.
 */
class StringUtilsTest {
  StringUtilsTest();

  static void run() {
    testParseCommandLine();
  }

  /**
   * Tests for parseCommandLine() function.
   */
  static void testParseCommandLine() {
    test('parseCommandLineEmptyInput', () =>
        expect(StringUtils.parseCommandLine(''),
            orderedEquals([]))
    );

    test('parseCommandLineTrailingWhitespace', () =>
        expect(StringUtils.parseCommandLine('ls ps and qs ts ss   '),
            orderedEquals(['ls', 'ps', 'and', 'qs', 'ts', 'ss']))
    );

    test('parseCommandLineQuotes', () =>
        expect(StringUtils.parseCommandLine('"ls" "ps and qs" ts ss'),
            orderedEquals(['ls', 'ps and qs', 'ts', 'ss']))
    );

    test('parseCommandLineEmptyStringQuotes', () =>
        expect(StringUtils.parseCommandLine('"ls" "" ts ss'),
            orderedEquals(['ls', '', 'ts', 'ss']))
    );

    test('parseCommandLineUnfinishedQuoteEnd', () =>
        expect(StringUtils.parseCommandLine('"ls" "" ts ss "'),
            equals(null))
    );

    test('parseCommandLineUnfinishedQuote', () =>
        expect(StringUtils.parseCommandLine('"ls" "" ts ss "  ff'),
            equals(null))
    );

    test('parseCommandLineRepeatedWhitespace', () =>
        expect(StringUtils.parseCommandLine('ls   ts ss'),
            orderedEquals(['ls', 'ts', 'ss']))
    );

    test('parseCommandLineConcatenation', () =>
        expect(StringUtils.parseCommandLine('"ls" "" ""ts "t"st c"dd"'),
            orderedEquals(['ls', '', 'ts', 'tst', 'cdd']))
    );

    test('parseCommandLineEndQuote', () =>
        expect(StringUtils.parseCommandLine('"ls" d"dd"'),
            orderedEquals(['ls', 'ddd']))
    );

    test('parseCommandLineMultipleConcatenation', () =>
        expect(StringUtils.parseCommandLine('"ls""ls""ls"'),
            orderedEquals(['lslsls']))
    );

    test('parseCommandLineSingleEarQuotes', () =>
        expect(StringUtils.parseCommandLine("'ls''ls' 'ls'dd"),
            orderedEquals(['lsls', 'lsdd']))
    );

    test('parseCommandLineFailedQuoteTypes', () =>
        expect(StringUtils.parseCommandLine("'njnj\""),
            equals(null))
    );

    test('parseCommandLineFailedQuoteTypesSwap', () =>
        expect(StringUtils.parseCommandLine("\"njnj'"),
            equals(null))
    );

    test('parseCommandLineMultipleQuoteTypes', () =>
        expect(StringUtils.parseCommandLine("\"njnj\" 'njkk'"),
               orderedEquals(['njnj', 'njkk']))
    );

    test('parseCommandLineEscapeQuotes', () =>
        /**
         * For readability: Strings used with no escaping-
         * \'njnj\' => \'njnj\'
         * 'nj\"kk' => nj\"kk
         * \"bb => "bb
         */
        expect(StringUtils.parseCommandLine("\\'njnj\\' 'nj\\\"kk' \\\"bb"),
            orderedEquals(["'njnj'", 'nj\\"kk', '"bb']))
    );

    test('parseCommandLineEscapeQuotesFail', () =>
        /**
         * For readability: Strings used with no escaping-
         * 'nj\'kk' => null
         */
        expect(StringUtils.parseCommandLine("'nj\\'kk'"), isNull)
    );

    test('parseCommandLineEndsWithEscape', () =>
        expect(StringUtils.parseCommandLine("vnfjd\\"), isNull)
    );
  }
}
