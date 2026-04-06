"Filed out from Dolphin Smalltalk"!

External.WindowsSystemLibrary
	subclass: #'OS.ICULibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'U_CHAR_CATEGORY_COUNT' -> 16r1E.
			'U_CHAR_NAME_ALIAS' -> 16r3.
			'U_COMBINING_SPACING_MARK' -> 16r8.
			'U_CONNECTOR_PUNCTUATION' -> 16r16.
			'U_CONTROL_CHAR' -> 16rF.
			'U_CURRENCY_SYMBOL' -> 16r19.
			'U_DASH_PUNCTUATION' -> 16r13.
			'U_DECIMAL_DIGIT_NUMBER' -> 16r9.
			'U_ENCLOSING_MARK' -> 16r7.
			'U_END_PUNCTUATION' -> 16r15.
			'U_EXTENDED_CHAR_NAME' -> 16r2.
			'U_FINAL_PUNCTUATION' -> 16r1D.
			'U_FOLD_CASE_DEFAULT' -> 16r0.
			'U_FOLD_CASE_EXCLUDE_SPECIAL_I' -> 16r1.
			'U_FORMAT_CHAR' -> 16r10.
			'U_GENERAL_OTHER_TYPES' -> 16r0.
			'U_INITIAL_PUNCTUATION' -> 16r1C.
			'U_LETTER_NUMBER' -> 16rA.
			'U_LINE_SEPARATOR' -> 16rD.
			'U_LOWERCASE_LETTER' -> 16r2.
			'U_MATH_SYMBOL' -> 16r18.
			'U_MAX_VERSION_LENGTH' -> 16r4.
			'U_MAX_VERSION_STRING_LENGTH' -> 16r14.
			'U_MODIFIER_LETTER' -> 16r4.
			'U_MODIFIER_SYMBOL' -> 16r1A.
			'U_NON_SPACING_MARK' -> 16r6.
			'U_OTHER_LETTER' -> 16r5.
			'U_OTHER_NUMBER' -> 16rB.
			'U_OTHER_PUNCTUATION' -> 16r17.
			'U_OTHER_SYMBOL' -> 16r1B.
			'U_PARAGRAPH_SEPARATOR' -> 16rE.
			'U_PRIVATE_USE_CHAR' -> 16r11.
			'U_SPACE_SEPARATOR' -> 16rC.
			'U_START_PUNCTUATION' -> 16r14.
			'U_SURROGATE' -> 16r12.
			'U_TITLECASE_LETTER' -> 16r3.
			'U_UNASSIGNED' -> 16r0.
			'U_UNICODE_CHAR_NAME' -> 16r0.
			'U_UPPERCASE_LETTER' -> 16r1.
			'UCHAR_AGE' -> 16r4000.
			'UCHAR_ALPHABETIC' -> 16r0.
			'UCHAR_ASCII_HEX_DIGIT' -> 16r1.
			'UCHAR_BIDI_CLASS' -> 16r1000.
			'UCHAR_BIDI_CONTROL' -> 16r2.
			'UCHAR_BIDI_MIRRORED' -> 16r3.
			'UCHAR_BIDI_MIRRORING_GLYPH' -> 16r4001.
			'UCHAR_BIDI_PAIRED_BRACKET' -> 16r400D.
			'UCHAR_BIDI_PAIRED_BRACKET_TYPE' -> 16r1015.
			'UCHAR_BLOCK' -> 16r1001.
			'UCHAR_CANONICAL_COMBINING_CLASS' -> 16r1002.
			'UCHAR_CASE_FOLDING' -> 16r4002.
			'UCHAR_CASE_IGNORABLE' -> 16r32.
			'UCHAR_CASE_SENSITIVE' -> 16r22.
			'UCHAR_CASED' -> 16r31.
			'UCHAR_CHANGES_WHEN_CASEFOLDED' -> 16r36.
			'UCHAR_CHANGES_WHEN_CASEMAPPED' -> 16r37.
			'UCHAR_CHANGES_WHEN_LOWERCASED' -> 16r33.
			'UCHAR_CHANGES_WHEN_NFKC_CASEFOLDED' -> 16r38.
			'UCHAR_CHANGES_WHEN_TITLECASED' -> 16r35.
			'UCHAR_CHANGES_WHEN_UPPERCASED' -> 16r34.
			'UCHAR_DASH' -> 16r4.
			'UCHAR_DECOMPOSITION_TYPE' -> 16r1003.
			'UCHAR_DEFAULT_IGNORABLE_CODE_POINT' -> 16r5.
			'UCHAR_DEPRECATED' -> 16r6.
			'UCHAR_DIACRITIC' -> 16r7.
			'UCHAR_DOUBLE_START' -> 16r3000.
			'UCHAR_EAST_ASIAN_WIDTH' -> 16r1004.
			'UCHAR_EMOJI' -> 16r39.
			'UCHAR_EMOJI_COMPONENT' -> 16r3D.
			'UCHAR_EMOJI_MODIFIER' -> 16r3B.
			'UCHAR_EMOJI_MODIFIER_BASE' -> 16r3C.
			'UCHAR_EMOJI_PRESENTATION' -> 16r3A.
			'UCHAR_EXTENDED_PICTOGRAPHIC' -> 16r40.
			'UCHAR_EXTENDER' -> 16r8.
			'UCHAR_FULL_COMPOSITION_EXCLUSION' -> 16r9.
			'UCHAR_GENERAL_CATEGORY' -> 16r1005.
			'UCHAR_GENERAL_CATEGORY_MASK' -> 16r2000.
			'UCHAR_GRAPHEME_BASE' -> 16rA.
			'UCHAR_GRAPHEME_CLUSTER_BREAK' -> 16r1012.
			'UCHAR_GRAPHEME_EXTEND' -> 16rB.
			'UCHAR_GRAPHEME_LINK' -> 16rC.
			'UCHAR_HANGUL_SYLLABLE_TYPE' -> 16r100B.
			'UCHAR_HEX_DIGIT' -> 16rD.
			'UCHAR_HYPHEN' -> 16rE.
			'UCHAR_ID_CONTINUE' -> 16rF.
			'UCHAR_ID_START' -> 16r10.
			'UCHAR_IDEOGRAPHIC' -> 16r11.
			'UCHAR_IDS_BINARY_OPERATOR' -> 16r12.
			'UCHAR_IDS_TRINARY_OPERATOR' -> 16r13.
			'UCHAR_INDIC_POSITIONAL_CATEGORY' -> 16r1016.
			'UCHAR_INDIC_SYLLABIC_CATEGORY' -> 16r1017.
			'UCHAR_INVALID_CODE' -> -16r1.
			'UCHAR_JOIN_CONTROL' -> 16r14.
			'UCHAR_JOINING_GROUP' -> 16r1006.
			'UCHAR_JOINING_TYPE' -> 16r1007.
			'UCHAR_LEAD_CANONICAL_COMBINING_CLASS' -> 16r1010.
			'UCHAR_LINE_BREAK' -> 16r1008.
			'UCHAR_LOGICAL_ORDER_EXCEPTION' -> 16r15.
			'UCHAR_LOWERCASE' -> 16r16.
			'UCHAR_LOWERCASE_MAPPING' -> 16r4004.
			'UCHAR_MASK_START' -> 16r2000.
			'UCHAR_MATH' -> 16r17.
			'UCHAR_MAX_VALUE' -> 16r10FFFF.
			'UCHAR_MIN_VALUE' -> 16r0.
			'UCHAR_NAME' -> 16r4005.
			'UCHAR_NFC_INERT' -> 16r27.
			'UCHAR_NFC_QUICK_CHECK' -> 16r100E.
			'UCHAR_NFD_INERT' -> 16r25.
			'UCHAR_NFD_QUICK_CHECK' -> 16r100C.
			'UCHAR_NFKC_INERT' -> 16r28.
			'UCHAR_NFKC_QUICK_CHECK' -> 16r100F.
			'UCHAR_NFKD_INERT' -> 16r26.
			'UCHAR_NFKD_QUICK_CHECK' -> 16r100D.
			'UCHAR_NONCHARACTER_CODE_POINT' -> 16r18.
			'UCHAR_NUMERIC_TYPE' -> 16r1009.
			'UCHAR_NUMERIC_VALUE' -> 16r3000.
			'UCHAR_OTHER_PROPERTY_START' -> 16r7000.
			'UCHAR_PATTERN_SYNTAX' -> 16r2A.
			'UCHAR_PATTERN_WHITE_SPACE' -> 16r2B.
			'UCHAR_POSIX_ALNUM' -> 16r2C.
			'UCHAR_POSIX_BLANK' -> 16r2D.
			'UCHAR_POSIX_GRAPH' -> 16r2E.
			'UCHAR_POSIX_PRINT' -> 16r2F.
			'UCHAR_POSIX_XDIGIT' -> 16r30.
			'UCHAR_PREPENDED_CONCATENATION_MARK' -> 16r3F.
			'UCHAR_QUOTATION_MARK' -> 16r19.
			'UCHAR_RADICAL' -> 16r1A.
			'UCHAR_REGIONAL_INDICATOR' -> 16r3E.
			'UCHAR_S_TERM' -> 16r23.
			'UCHAR_SCRIPT' -> 16r100A.
			'UCHAR_SCRIPT_EXTENSIONS' -> 16r7000.
			'UCHAR_SEGMENT_STARTER' -> 16r29.
			'UCHAR_SENTENCE_BREAK' -> 16r1013.
			'UCHAR_SIMPLE_CASE_FOLDING' -> 16r4006.
			'UCHAR_SIMPLE_LOWERCASE_MAPPING' -> 16r4007.
			'UCHAR_SIMPLE_TITLECASE_MAPPING' -> 16r4008.
			'UCHAR_SIMPLE_UPPERCASE_MAPPING' -> 16r4009.
			'UCHAR_SOFT_DOTTED' -> 16r1B.
			'UCHAR_STRING_START' -> 16r4000.
			'UCHAR_TERMINAL_PUNCTUATION' -> 16r1C.
			'UCHAR_TITLECASE_MAPPING' -> 16r400A.
			'UCHAR_TRAIL_CANONICAL_COMBINING_CLASS' -> 16r1011.
			'UCHAR_UNIFIED_IDEOGRAPH' -> 16r1D.
			'UCHAR_UPPERCASE' -> 16r1E.
			'UCHAR_UPPERCASE_MAPPING' -> 16r400C.
			'UCHAR_VARIATION_SELECTOR' -> 16r24.
			'UCHAR_VERTICAL_ORIENTATION' -> 16r1018.
			'UCHAR_WHITE_SPACE' -> 16r1F.
			'UCHAR_WORD_BREAK' -> 16r1014.
			'UCHAR_XID_CONTINUE' -> 16r20.
			'UCHAR_XID_START' -> 16r21
		}!

OS.ICULibrary guid: (Core.GUID fromString: '{cf17a85e-24da-4549-a6bf-03591cd93858}')!

OS.ICULibrary comment: ''!

!OS.ICULibrary methodsFor!

icuError: errInteger in: nameString
	^self error: 'ICU error ' , errInteger printString , ' in ' , nameString!

u_charAge: aCharacter
	| buf |
	buf := ByteArray newFixed: U_MAX_VERSION_LENGTH.
	self u_charAge: aCharacter versionArray: buf.
	^buf!

u_charAge: aCharacter versionArray: versionArray
"/**
 * Get the 'age' of the code point.
 * The 'age' is the Unicode version when the code point was first
 * designated (as a non-character or for Private Use)
 * or assigned a character.
 * This can be useful to avoid emitting code points to receiving
 * processes that do not accept newer characters.
 * The data is from the UCD file DerivedAge.txt.
 *
 * @param c The code point.
 * @param versionArray The Unicode version number array, to be filled in.
 *
 * @stable ICU 2.1
 */
U_CAPI void U_EXPORT2
u_charAge(UChar32 c, UVersionInfo versionArray);"

	<cdecl: void u_charAge char32 uint32*>
	^self invalidCall: _failureCode!

u_charName: aCharacter nameChoice: anInteger
	| len error name |
	error := ByteArray new: 4.
	len := self
				u_charName: aCharacter
				nameChoice: anInteger
				buffer: nil
				bufferLength: 0
				pErrorCode: error.
	name := Utf8String new: len.
	error int32AtOffset: 0 put: 0.
	self
		u_charName: aCharacter
		nameChoice: anInteger
		buffer: name
		bufferLength: len + 1
		pErrorCode: error.
	(error int32AtOffset: 0) > 0 ifTrue: [^self icuError: (error int32AtOffset: 0) in: 'u_charName'].
	^name!

u_charName: aCharacter nameChoice: choiceInteger buffer: anAnsiString bufferLength: lengthInteger pErrorCode: aUInt32
"Private - /**
 * Retrieve the name of a Unicode character.
 * Depending on <code>nameChoice</code>, the character name written
 * into the buffer is the 'modern' name or the name that was defined
 * in Unicode version 1.0.
 * The name contains only 'invariant' characters
 * like A-Z, 0-9, space, and '-'.
 * Unicode 1.0 names are only retrieved if they are different from the modern
 * names and if the data file contains the data for them. gennames may or may
 * not be called with a command line option to include 1.0 names in unames.dat.
 *
 * @param code The character (code point) for which to get the name.
 *             It must be <code>0<=code<=0x10ffff</code>.
 * @param nameChoice Selector for which name to get.
 * @param buffer Destination address for copying the name.
 *               The name will always be zero-terminated.
 *               If there is no name, then the buffer will be set to the empty string.
 * @param bufferLength <code>==sizeof(buffer)</code>
 * @param pErrorCode Pointer to a UErrorCode variable;
 *        check for <code>U_SUCCESS()</code> after <code>u_charName()</code>
 *        returns.
 * @return The length of the name, or 0 if there is no name for this character.
 *         If the bufferLength is less than or equal to the length, then the buffer
 *         contains the truncated name and the returned length indicates the full
 *         length of the name.
 *         The length does not include the zero-termination.
 *
 * @see UCharNameChoice
 * @see u_charFromName
 * @see u_enumCharNames
 * @stable ICU 2.0
 */"
	<cdecl: int32 u_charName char32 int32 lpstr8 int32 uint32*>
	^self invalidCall: _failureCode!

u_charType: aCharacter
"/**
 * Returns the general category value for the code point.
 *
 * Same as java.lang.Character.getType().
 *
 * @param c the code point to be tested
 * @return the general category (UCharCategory) value
 *
 * @see UCharCategory
 * @stable ICU 2.0
 */"

	<cdecl: int8 u_charType char32>
	^self invalidCall: _failureCode!

u_countChar32: s length: length
"/**
 * Count Unicode code points in the length UChar code units of the string.
 * A code point may occupy either one or two UChar code units.
 * Counting code points involves reading all code units.
 *
 * This functions is basically the inverse of the U16_FWD_N() macro (see utf.h).
 *
 * @param s The input string.
 * @param length The number of UChar code units to be checked, or -1 to count all
 *               code points before the first NUL (U+0000).
 * @return The number of code points in the specified code units.
 * @stable ICU 2.0
 */
U_CAPI int32_t U_EXPORT2
u_countChar32(const UChar *s, int32_t length);"
	<cdecl: int32 u_countChar32 char16* int32>
	^self invalidCall: _failureCode!

u_foldCase: aCharacter options: anInteger
"/**
 * The given character is mapped to its case folding equivalent according to
 * UnicodeData.txt and CaseFolding.txt;
 * if the character has no case folding equivalent, the character
 * itself is returned.
 *
 * This function only returns the simple, single-code point case mapping.
 * Full case mappings should be used whenever possible because they produce
 * better results by working on whole strings.
 * They take into account the string context and the language and can map
 * to a result string with a different length as appropriate.
 * Full case mappings are applied by the string case mapping functions,
 * see ustring.h and the UnicodeString class.
 * See also the User Guide chapter on C/POSIX migration:
 * http://icu-project.org/userguide/posix.html#case_mappings
 *
 * @param c the code point to be mapped
 * @param options Either U_FOLD_CASE_DEFAULT or U_FOLD_CASE_EXCLUDE_SPECIAL_I
 * @return the Simple_Case_Folding of the code point, if any;
 *         otherwise the code point itself.
 * @stable ICU 2.0
 */"
	<cdecl: char32 u_foldCase char32 uint32>
	^self invalidCall: _failureCode!

u_getDataVersion
	| buf |
	buf := ByteArray newFixed: ##(U_MAX_VERSION_LENGTH + 4).
	self u_getDataVersion: buf status: buf yourAddress + U_MAX_VERSION_LENGTH.
	(buf int32AtOffset: U_MAX_VERSION_LENGTH) > 0
		ifTrue: [^self icuError: (buf int32AtOffset: U_MAX_VERSION_LENGTH) in: 'u_getDataVersion'].
	^buf!

u_getDataVersion: dataVersionFillin status: status
"/**
 * Retrieves the data version from icuver and stores it in dataVersionFillin.
 * 
 * @param dataVersionFillin icuver data version information to be filled in if not-null
 * @param status stores the error code from the calls to resource bundle
 * 
 * @stable ICU 49
 */
U_CAPI void U_EXPORT2 u_getDataVersion(UVersionInfo dataVersionFillin, UErrorCode *status);
"

	<cdecl: void u_getDataVersion uint32* int32*>
	^self invalidCall: _failureCode!

u_getUnicodeVersion
	| buf |
	buf := ByteArray newFixed: U_MAX_VERSION_LENGTH.
	self u_getUnicodeVersion: buf.
	^buf!

u_getUnicodeVersion: versionArray
"Private - /**
 * Gets the Unicode version information.
 * The version array is filled in with the version information
 * for the Unicode standard that is currently used by ICU.
 * For example, Unicode version 3.1.1 is represented as an array with
 * the values { 3, 1, 1, 0 }.
 *
 * @param versionArray an output array that will be filled in with
 *                     the Unicode version number
 * @stable ICU 2.0
 */
U_CAPI void U_EXPORT2
u_getUnicodeVersion(UVersionInfo versionArray);"

	<cdecl: void u_getUnicodeVersion uint32*>
	^self invalidCall: _failureCode!

u_getVersion
	| buf |
	buf := ByteArray new: U_MAX_VERSION_LENGTH.
	self u_getVersion: buf.
	^buf!

u_getVersion: versionArray
	"Private - /**
 * Gets the ICU release version.  The version array stores the version information
 * for ICU.  For example, release ""1.3.31.2"" is then represented as 0x01031F02.
 * Definition of this function lives in putil.c
 *
 * @param versionArray the version # information, the result will be filled in
 * @stable ICU 2.0
 */
U_CAPI void U_EXPORT2
u_getVersion(UVersionInfo versionArray);"

	<cdecl: void u_getVersion uint32*>
	^self invalidCall: _failureCode!

u_hasBinaryProperty: aCharacter which: anIntege
"/**
 * Check a binary Unicode property for a code point.
 *
 * Unicode, especially in version 3.2, defines many more properties than the
 * original set in UnicodeData.txt.
 *
 * The properties APIs are intended to reflect Unicode properties as defined
 * in the Unicode Character Database (UCD) and Unicode Technical Reports (UTR).
 * For details about the properties see http://www.unicode.org/ucd/ .
 * For names of Unicode properties see the UCD file PropertyAliases.txt.
 *
 * Important: If ICU is built with UCD files from Unicode versions below 3.2,
 * then properties marked with ""new in Unicode 3.2"" are not or not fully available.
 *
 * @param c Code point to test.
 * @param which UProperty selector constant, identifies which binary property to check.
 *        Must be UCHAR_BINARY_START<=which<UCHAR_BINARY_LIMIT.
 * @return true or false according to the binary Unicode property value for c.
 *         Also false if 'which' is out of bounds or if the Unicode version
 *         does not have data for the property at all, or not for this code point.
 *
 * @see UProperty
 * @see u_getBinaryPropertySet
 * @see u_getIntPropertyValue
 * @see u_getUnicodeVersion
 * @stable ICU 2.1
 */
"
	<cdecl: bool8 u_hasBinaryProperty char32 uint32>
	^self invalidCall: _failureCode!

u_isalpha: aCharacter
"/**
 * Determines whether the specified code point is a letter character.
 * True for general categories ""L"" (letters).
 *
 * Same as java.lang.Character.isLetter().
 *
 * In addition to being equivalent to a Java function, this also serves
 * as a C/POSIX migration function.
 * See the comments about C/POSIX character classification functions in the
 * documentation at the top of this header file.
 *
 * @param c the code point to be tested
 * @return true if the code point is a letter character
 *
 * @see u_isdigit
 * @see u_isalnum
 * @stable ICU 2.0
 */"
	<cdecl: bool8 u_isalpha char32>
	^self invalidCall: _failureCode!

u_iscntrl: aCharacter
"/**
 * Determines whether the specified code point is a control character
 * (as defined by this function).
 * A control character is one of the following:
 * - ISO 8-bit control character (U+0000..U+001f and U+007f..U+009f)
 * - U_CONTROL_CHAR (Cc)
 * - U_FORMAT_CHAR (Cf)
 * - U_LINE_SEPARATOR (Zl)
 * - U_PARAGRAPH_SEPARATOR (Zp)
 *
 * This is a C/POSIX migration function.
 * See the comments about C/POSIX character classification functions in the
 * documentation at the top of this header file.
 *
 * @param c the code point to be tested
 * @return true if the code point is a control character
 *
 * @see UCHAR_DEFAULT_IGNORABLE_CODE_POINT
 * @see u_isprint
 * @stable ICU 2.0
 */"
	<cdecl: bool8 u_iscntrl char32>
	^self invalidCall: _failureCode!

u_isgraph: aCharacter
"/**
 * Determines whether the specified code point is a ""graphic"" character
 * (printable, excluding spaces).
 * true for all characters except those with general categories
 * ""Cc"" (control codes), ""Cf"" (format controls), ""Cs"" (surrogates),
 * ""Cn"" (unassigned), and ""Z"" (separators).
 *
 * This is a C/POSIX migration function.
 * See the comments about C/POSIX character classification functions in the
 * documentation at the top of this header file.
 *
 * @param c the code point to be tested
 * @return true if the code point is a ""graphic"" character
 *
 * @stable ICU 2.6
 */"
	<cdecl: bool8 u_isgraph char32>
	^self invalidCall: _failureCode!

u_ispunct: aCharacter
"/**
 * Determines whether the specified code point is a punctuation character.
 * True for characters with general categories ""P"" (punctuation).
 *
 * This is a C/POSIX migration function.
 * See the comments about C/POSIX character classification functions in the
 * documentation at the top of this header file.
 *
 * @param c the code point to be tested
 * @return true if the code point is a punctuation character
 *
 * @stable ICU 2.6
 */"
	<cdecl: bool8 u_ispunct char32>
	^self invalidCall: _failureCode!

u_strFoldCase: destString destCapacity: capacityInteger src: srcString srcLength: lenInteger options: optionsInteger pErrorCode: anInt32
	"Private - /**
 * Case-folds the characters in a string.
 *
 * Case-folding is locale-independent and not context-sensitive,
 * but there is an option for whether to include or exclude mappings for dotted I
 * and dotless i that are marked with 'T' in CaseFolding.txt.
 *
 * The result may be longer or shorter than the original.
 * The source string and the destination buffer are allowed to overlap.
 *
 * @param dest      A buffer for the result string. The result will be zero-terminated if
 *                  the buffer is large enough.
 * @param destCapacity The size of the buffer (number of UChars). If it is 0, then
 *                  dest may be NULL and the function will only return the length of the result
 *                  without writing any of the result string.
 * @param src       The original string
 * @param srcLength The length of the original string. If -1, then src must be zero-terminated.
 * @param options   Either U_FOLD_CASE_DEFAULT or U_FOLD_CASE_EXCLUDE_SPECIAL_I
 * @param pErrorCode Must be a valid pointer to an error code value,
 *                  which must not indicate a failure before the function call.
 * @return The length of the result string. It may be greater than destCapacity. In that case,
 *         only some of the result was written to the destination buffer.
 * @stable ICU 2.0
 */"

	<cdecl: int32 u_strFoldCase char16* int32 char16* int32 uint32 int32*>
	^self invalidCall: _failureCode!

u_strFoldCase: aString options: anInteger
	| errorCode destLength dest srcLength |
	"Attempt conversion in place for mainstream case"
	destLength := self
				u_strFoldCase: (dest := aString asUtf16StringCopy)
				destCapacity: (srcLength := dest size) + 1
				src: dest
				srcLength: srcLength
				options: anInteger
				pErrorCode: (errorCode := ByteArray newFixed: 4).
	destLength == srcLength ifTrue: [^dest].
	"The above in-place conversion may fail, in which (rare) case we need to allocate a large buffer and try again."
	errorCode int32AtOffset: 0 put: 0.
	self
		u_strFoldCase: (dest := Utf16String new: destLength)
		destCapacity: destLength + 1
		src: aString
		srcLength: srcLength
		options: anInteger
		pErrorCode: errorCode.
	(errorCode int32AtOffset: 0) > 0
		ifTrue: [^self icuError: (errorCode int32AtOffset: 0) in: 'u_strFoldCase'].
	^dest!

u_strFromUTF8WithSub: aUtf8String
	| dest buf destLength |
	buf := ByteArray newFixed: 8.
	self
		u_strFromUTF8WithSub: nil
		destCapacity: 0
		pDestLength: buf
		src: aUtf8String
		srcLength: aUtf8String size
		subchar: 16rFFFD
		pNumSubstitutions: nil
		pErrorCode: buf yourAddress + 4.
	destLength := buf int32AtOffset: 0.
	buf int32AtOffset: 4 put: 0.
	self
		u_strFromUTF8WithSub: (dest := Utf16String newFixed: destLength)
		destCapacity: destLength + 1
		pDestLength: buf
		src: aUtf8String
		srcLength: aUtf8String size
		subchar: 16rFFFD
		pNumSubstitutions: nil
		pErrorCode: buf yourAddress + 4.
	(buf int32AtOffset: 4) > 0
		ifTrue: [^self icuError: (buf int32AtOffset: 4) in: 'u_strFromUTF8WithSub'].
	^dest!

u_strFromUTF8WithSub: dest destCapacity: destInteger pDestLength: anInt32 src: aUtf8String srcLength: srcInteger subchar: aCharacter pNumSubstitutions: substInst32 pErrorCode: errInt32
	<cdecl: intptr u_strFromUTF8WithSub char16* int32 int32* lpvoid int32 char32 int32* uint32*>
	^self invalidCall: _failureCode
!

u_strToLower: destString destCapacity: capacityInteger src: srcString srcLength: lenInteger locale: localeString pErrorCode: anInt32
	<cdecl: int32 u_strToLower char16* int32 char16* int32 char8* int32*>
	^self invalidCall: _failureCode!

u_strToLower: aString locale: isoString
	| srcLength errorCode destLength dest |
	destLength := self
				u_strToLower: (dest := aString asUtf16StringCopy)
				destCapacity: (srcLength := dest size) + 1
				src: dest
				srcLength: srcLength
				locale: isoString
				pErrorCode: (errorCode := ByteArray newFixed: 4).
	destLength == srcLength ifTrue: [^dest].
	"The above in-place conversion may fail, in which (rare) case we need to allocate a large buffer and try again."
	dest := Utf16String new: destLength.
	errorCode int32AtOffset: 0 put: 0.
	self
		u_strToLower: dest
		destCapacity: destLength + 1
		src: aString
		srcLength: srcLength
		locale: isoString
		pErrorCode: errorCode.
	(errorCode int32AtOffset: 0) > 0
		ifTrue: [^self icuError: (errorCode int32AtOffset: 0) in: 'u_strToLower'].
	^dest!

u_strToTitle: destString destCapacity: capacityInteger src: srcString srcLength: lenInteger titleIter: aCallback locale: localeString pErrorCode: anInt32
	"Private - /**
 * Titlecase a string.
 * Casing is locale-dependent and context-sensitive.
 * Titlecasing uses a break iterator to find the first characters of words
 * that are to be titlecased. It titlecases those characters and lowercases
 * all others.
 *
 * The titlecase break iterator can be provided to customize for arbitrary
 * styles, using rules and dictionaries beyond the standard iterators.
 * It may be more efficient to always provide an iterator to avoid
 * opening and closing one for each string.
 * The standard titlecase iterator for the root locale implements the
 * algorithm of Unicode TR 21.
 *
 * This function uses only the setText(), first() and next() methods of the
 * provided break iterator.
 *
 * The result may be longer or shorter than the original.
 * The source string and the destination buffer are allowed to overlap.
 *
 * @param dest      A buffer for the result string. The result will be zero-terminated if
 *                  the buffer is large enough.
 * @param destCapacity The size of the buffer (number of UChars). If it is 0, then
 *                  dest may be NULL and the function will only return the length of the result
 *                  without writing any of the result string.
 * @param src       The original string
 * @param srcLength The length of the original string. If -1, then src must be zero-terminated.
 * @param titleIter A break iterator to find the first characters of words
 *                  that are to be titlecased.
 *                  If none is provided (NULL), then a standard titlecase
 *                  break iterator is opened.
 * @param locale    The locale to consider, or "" for the root locale or NULL for the default locale.
 * @param pErrorCode Must be a valid pointer to an error code value,
 *                  which must not indicate a failure before the function call.
 * @return The length of the result string. It may be greater than destCapacity. In that case,
 *         only some of the result was written to the destination buffer.
 * @stable ICU 2.1
 */"

	<cdecl: int32 u_strToTitle char16* int32 char16* int32 void* char8* int32*>
	^self invalidCall: _failureCode!

u_strToTitle: aString locale: isoString
	| errorCode destLength dest srcLength |
	destLength := self
				u_strToTitle: (dest := aString asUtf16StringCopy)
				destCapacity: (srcLength := dest size) + 1
				src: dest
				srcLength: srcLength
				titleIter: nil
				locale: isoString
				pErrorCode: (errorCode := ByteArray newFixed: 4).
	destLength == srcLength ifTrue: [^dest].
	dest := Utf16String new: destLength.
	errorCode int32AtOffset: 0 put: 0.
	self
		u_strToTitle: dest
		destCapacity: destLength + 1
		src: aString
		srcLength: srcLength
		titleIter: nil
		locale: isoString
		pErrorCode: errorCode.
	(errorCode int32AtOffset: 0) > 0
		ifTrue: [^self icuError: (errorCode int32AtOffset: 0) in: 'u_strToTitle'].
	^dest!

u_strToUpper: destString destCapacity: capacityInteger src: srcString srcLength: lenInteger locale: localeString pErrorCode: anInt32
	<cdecl: int32 u_strToUpper char16* int32 char16* int32 char8* int32*>
	^self invalidCall: _failureCode!

u_strToUpper: aString locale: isoString
	| srcLength errorCode destLength dest |
	destLength := self
				u_strToUpper: (dest := aString asUtf16StringCopy)
				destCapacity: (srcLength := dest size) + 1
				src: dest
				srcLength: srcLength
				locale: isoString
				pErrorCode: (errorCode := ByteArray newFixed: 4).
	destLength == srcLength ifTrue: [^dest].
	"The above in-place conversion may fail (e.g. ß -> SS), in which (rare) case we need to allocate a large buffer and try again."
	dest := Utf16String new: destLength.
	errorCode int32AtOffset: 0 put: 0.
	self
		u_strToUpper: dest
		destCapacity: destLength + 1
		src: aString
		srcLength: srcLength
		locale: isoString
		pErrorCode: errorCode.
	(errorCode int32AtOffset: 0) > 0
		ifTrue: [^self icuError: (errorCode int32AtOffset: 0) in: 'u_strToUpper'].
	^dest!

u_tolower: aCharacter
"/**
 * The given character is mapped to its lowercase equivalent according to
 * UnicodeData.txt; if the character has no lowercase equivalent, the character
 * itself is returned.
 *
 * Same as java.lang.Character.toLowerCase().
 *
 * This function only returns the simple, single-code point case mapping.
 * Full case mappings should be used whenever possible because they produce
 * better results by working on whole strings.
 * They take into account the string context and the language and can map
 * to a result string with a different length as appropriate.
 * Full case mappings are applied by the string case mapping functions,
 * see ustring.h and the UnicodeString class.
 * See also the User Guide chapter on C/POSIX migration:
 * http://icu-project.org/userguide/posix.html#case_mappings
 *
 * @param c the code point to be mapped
 * @return the Simple_Lowercase_Mapping of the code point, if any;
 *         otherwise the code point itself.
 * @stable ICU 2.0
 */"
	<cdecl: char32 u_tolower char32>
	^self invalidCall: _failureCode!

u_toupper: aCharacter
"/**
 * The given character is mapped to its uppercase equivalent according to UnicodeData.txt;
 * if the character has no uppercase equivalent, the character itself is
 * returned.
 *
 * Same as java.lang.Character.toUpperCase().
 *
 * This function only returns the simple, single-code point case mapping.
 * Full case mappings should be used whenever possible because they produce
 * better results by working on whole strings.
 * They take into account the string context and the language and can map
 * to a result string with a different length as appropriate.
 * Full case mappings are applied by the string case mapping functions,
 * see ustring.h and the UnicodeString class.
 * See also the User Guide chapter on C/POSIX migration:
 * http://icu-project.org/userguide/posix.html#case_mappings
 *
 * @param c the code point to be mapped
 * @return the Simple_Uppercase_Mapping of the code point, if any;
 *         otherwise the code point itself.
 * @stable ICU 2.0
 */"

	<cdecl: char32 u_toupper char32>
	^self invalidCall: _failureCode!

u_versionToString: versionArray versionString: versionString
	"/**
 * Write a string with dotted-decimal version information according
 * to the input UVersionInfo.
 * Definition of this function lives in putil.c
 *
 * @param versionArray The version information to be written as a string.
 * @param versionString A string buffer that will be filled in with
 *                      a string corresponding to the numeric version
 *                      information in versionArray.
 *                      The buffer size must be at least U_MAX_VERSION_STRING_LENGTH.
 * @stable ICU 2.4
 */
U_CAPI void U_EXPORT2
u_versionToString(const UVersionInfo versionArray, char *versionString);"

	<cdecl: void u_versionToString uint32* char8*>
	^self invalidCall: _failureCode! !

!OS.ICULibrary categoriesForMethods!
icuError:in:!error handling!private! !
u_charAge:!character properties!public!version information! !
u_charAge:versionArray:!character properties!public!version information! !
u_charName:nameChoice:!character properties!public! !
u_charName:nameChoice:buffer:bufferLength:pErrorCode:!character properties!private! !
u_charType:!character properties!public! !
u_countChar32:length:!public!string handling! !
u_foldCase:options:!case conversions!public! !
u_getDataVersion!public!version information! !
u_getDataVersion:status:!private!version information! !
u_getUnicodeVersion!public!version information! !
u_getUnicodeVersion:!private!version information! !
u_getVersion!public!version information! !
u_getVersion:!private!version information! !
u_hasBinaryProperty:which:!character properties!public! !
u_isalpha:!character properties!public! !
u_iscntrl:!character properties!public! !
u_isgraph:!character properties!public! !
u_ispunct:!character properties!public! !
u_strFoldCase:destCapacity:src:srcLength:options:pErrorCode:!case conversions!private! !
u_strFoldCase:options:!case conversions!public! !
u_strFromUTF8WithSub:!encoding conversions!public! !
u_strFromUTF8WithSub:destCapacity:pDestLength:src:srcLength:subchar:pNumSubstitutions:pErrorCode:!encoding conversions!private! !
u_strToLower:destCapacity:src:srcLength:locale:pErrorCode:!case conversions!private! !
u_strToLower:locale:!case conversions!public! !
u_strToTitle:destCapacity:src:srcLength:titleIter:locale:pErrorCode:!case conversions!private! !
u_strToTitle:locale:!case conversions!public! !
u_strToUpper:destCapacity:src:srcLength:locale:pErrorCode:!case conversions!private! !
u_strToUpper:locale:!case conversions!public! !
u_tolower:!case conversions!public! !
u_toupper:!case conversions!public! !
u_versionToString:versionString:!public!version information! !
!

!OS.ICULibrary class methodsFor!

fileName
	"Answer the host system file name for the library"

	^'icuuc'!

sharedVariableName
	^#{OS.ICU}! !

!OS.ICULibrary class categoriesForMethods!
fileName!constants!public! !
sharedVariableName!constants!private! !
!

