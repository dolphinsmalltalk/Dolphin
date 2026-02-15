"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.FilenameTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Constants} #{OS.CRTConstants})
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.FilenameTest guid: (Core.GUID fromString: '{ec8f9547-fbd4-4905-9944-c6614ee9cc1b}')!

Core.Tests.FilenameTest comment: ''!

!Core.Tests.FilenameTest methodsFor!

buildTestPathOfLength: anInteger
	| maxPath |
	maxPath := String writeStream.
	maxPath nextPutAll: 'c:\'.
	0 to: anInteger - 8 do: [:i | maxPath nextPut: ('a🍺cd£eghij\' at: i % 11 + 1)].
	maxPath := maxPath contents.
	maxPath last = $\ ifTrue: [maxPath := maxPath allButLast , 'a'].
	maxPath := maxPath , '.txt'.
	self assert: maxPath size equals: anInteger.
	^maxPath!

longFilenamesEnabled
	"Answer whether long filenames are enabled in the host OS. Note that changes to the reg value do not take effect until after a reboot, so this is not conclusive."

	^OS.NtDll rtlAreLongPathsEnabled and: [OS.Kernel32 isWindows11OrGreater]!

longPathPrefix
	^self longFilenamesEnabled ifTrue: [''] ifFalse: ['\\?\']!

maxFname
	^_MAX_FNAME!

printFilenameOfLength: anInteger on: path
	(1 to: anInteger) do: [:i | path nextPut: (Character codePoint: $a codePoint + (i % 10))].
	path nextPut: $..
	(1 to: _MAX_EXT - 1) do: [:i | path nextPut: (Character codePoint: $a codePoint + (i % 10))]!

testCanonicalizePath
	"Test File class>>composePath:subPath:"

	"Mainstream case"

	self assert: (Filename canonicalizePath: 'd:\£oo\bar\a🐬b\baz.txt')
		equals: 'd:\£oo\bar\a🐬b\baz.txt'.
	"Unecessary long path prefix"
	self assert: (Filename canonicalizePath: '\\?\d:\£oo\bar\a🐬b\baz.txt')
		equals: 'd:\£oo\bar\a🐬b\baz.txt'.
	"Empty - inconsistent behaviour, although consistently inconsistent with PathCombine API"
	self assert: (Filename canonicalizePath: '') equals: '\'.
	self assert: (Filename canonicalizePath: 'c:') equals: 'c:'.

	".. and . components"
	self assert: (Filename canonicalizePath: 'C:\£oo\bar\a£\..\.\..\🐬.txt')
		equals: 'C:\£oo\🐬.txt'.
	self assert: (Filename canonicalizePath: '.\🐬-🐬.txt') equals: '🐬-🐬.txt'.

	"MAX_PATH"
	self assert: (Filename canonicalizePath: 'c:\' , (String new: MAX_PATH - 4 withAll: $a))
		equals: 'c:\' , (String new: MAX_PATH - 4 withAll: $a).

	"> MAX_PATH"
	self assert: (Filename canonicalizePath: 'c:\' , (String new: MAX_PATH - 3 withAll: $a))
		equals: self longPathPrefix , 'c:\' , (String new: MAX_PATH - 3 withAll: $a).
	self assert: (Filename canonicalizePath: '\\?\c:\' , (String new: MAX_PATH - 3 withAll: $a))
		equals: self longPathPrefix , 'c:\' , (String new: MAX_PATH - 3 withAll: $a)!

testClassAppendPathSeparator
	"N.B. To path is assumed to be a directory only if it has a trailing slash, *otherwise the last portion is ignored*"

	self assert: (Filename appendPathDelimiter: 'c:\') equals: 'c:\'.
	self assert: (Filename appendPathDelimiter: 'c:/') equals: 'c:/'.
	self assert: (Filename appendPathDelimiter: 'c:.') equals: 'c:.\'.
	self assert: (Filename appendPathDelimiter: '') equals: '\'.
	self assert: (Filename appendPathDelimiter: 'a🖕b') equals: 'a🖕b\'.
	self assert: (Filename appendPathDelimiter: 'a') equals: 'a\'.
	self assert: (Filename appendPathDelimiter: 'a\') equals: 'a\'.
	self assert: (Filename appendPathDelimiter: 'a\\') equals: 'a\\'.
	self assert: (Filename appendPathDelimiter: '\') equals: '\'.
	self assert: (Filename appendPathDelimiter: '/') equals: '/'.
	self assert: (Filename appendPathDelimiter: 'a/') equals: 'a/'!

testClassDefaultExtension
	| s s2 |
	#(#('' '' '') #('a.' '' 'a') #('a.' '.' 'a.') #('a' '' 'a') #('a' '.b' 'a.b') #('a.' 'b' 'a.b') #('a.' '.b' 'a.b') #('a.b' '.c' 'a.b') #('abc' 'txt' 'abc.txt') #('abc.def\xyz' '.txt' 'abc.def\xyz.txt') #('abc.d\xy' 'txt' 'abc.d\xy.txt') #('x\' '🐬' 'x\.🐬') #('文字化け\你🐬好' 'dll' '文字化け\你🐬好.dll') #('x\abc.a🐬' 'txt' 'x\abc.a🐬'))
		do: 
			[:each |
			| actual |
			actual := Filename default: each first extension: each second.
			self assert: actual equals: each last.
			actual := Filename default: each first asUtf16String extension: each second asUtf16String.
			self assert: actual equals: each last].
	"Long paths"
	s := String writeStream.
	s nextPutAll: 'c:'.
	10 timesRepeat: 
			[s
				nextPut: $\;
				nextPutAll: GUID newUnique idlString].
	s := s contents.
	self assert: s size > MAX_PATH.
	s2 := Filename default: s extension: 'txt'.
	self assert: s2 equals: s , '.txt'.
	s2 := Filename default: s extension: '.blah'.
	self assert: s2 equals: s , '.blah'!

testClassPathExtension
	| s s2 |
	#(#('' '' '') #('' 'a' '.a') #('' '.a' '.a') #('a' '' 'a') #('a.' '' 'a') #('a' 'b' 'a.b') #('a' '.b' 'a.b') #('a.b' 'c' 'a.c') #('a.exe' '.dll' 'a.dll') #('c:' 'bat' 'c:.bat') #('\' '.cmd' '\.cmd') #('ab\cd.exe' 'dll' 'ab\cd.dll') #('a\' 'b' 'a\.b') #('a.b' '' 'a') #('\a\b\.c' '' '\a\b\') #('a.longlonglonglongextension' '.evenlongerlonglonglonglongextension' 'a.evenlongerlonglonglonglongextension') #('c:\wibble\wobble' '.blah' 'c:\wibble\wobble.blah') #('文字化け.txt' '你🐬好' '文字化け.你🐬好') #('文字化け.你🐬好' '.txt' '文字化け.txt'))
		do: 
			[:each |
			| actual |
			actual := Filename path: each first extension: each second.
			self assert: actual equals: each last].
	"Long paths"
	s := String writeStream.
	s nextPutAll: 'c:'.
	10 timesRepeat: 
			[s
				nextPut: $\;
				nextPutAll: GUID newUnique idlString].
	s := s contents.
	self assert: s size > MAX_PATH.
	s2 := Filename path: s extension: 'txt'.
	self assert: s2 equals: s , '.txt'.
	s2 := Filename path: s extension: '.blah'.
	self assert: s2 equals: s , '.blah'!

testClassRelativePathOfTo
	"N.B. To path is assumed to be a directory only if it has a trailing slash, *otherwise the last portion is ignored*"

	self assert: (Filename relativePathOf: '.' to: '.') equals: '.'.
	self assert: (Filename relativePathOf: '..' to: '.') equals: '..'.
	self assert: (Filename relativePathOf: '..\' to: '.') equals: '..\'.
	self assert: (Filename relativePathOf: '..' to: '.\') equals: '..'.
	self assert: (Filename relativePathOf: '.' to: '..') equals: '.'.
	self assert: (Filename relativePathOf: '.\' to: '..\') equals: ''.
	self assert: (Filename relativePathOf: '.\' to: '..') equals: ''.
	self assert: (Filename relativePathOf: '.' to: '..\') equals: '.'.
	self assert: (Filename relativePathOf: '.\' to: '..\') equals: ''.
	self assert: (Filename relativePathOf: 'c:\' to: 'd:\') equals: 'c:\'.
	self assert: (Filename relativePathOf: 'c:\1\a🐬b.txt' to: 'c:\') equals: '1\a🐬b.txt'.
	self assert: (Filename relativePathOf: 'c:\1\a🐬b.txt' to: 'c:\1\') equals: 'a🐬b.txt'.
	self assert: (Filename relativePathOf: 'c:\1\a🐬b.txt' to: 'c:\1') equals: '1\a🐬b.txt'.
	self assert: (Filename relativePathOf: 'c:\1\a🐬b.txt' to: 'c:\1.txt') equals: '1\a🐬b.txt'.
	self assert: (Filename relativePathOf: 'c:\1\a🐬b.txt' to: 'c:\2\') equals: '..\1\a🐬b.txt'.
	self assert: (Filename relativePathOf: 'c:\1\a🐬b.txt' to: 'c:\2') equals: '1\a🐬b.txt'.
	self assert: (Filename relativePathOf: 'c:\1\a🐬b.txt' to: 'c:\2.txt') equals: '1\a🐬b.txt'.
	self assert: (Filename relativePathOf: 'c:\1\11\a🐬b.txt' to: 'c:\1') equals: '1\11\a🐬b.txt'.
	self assert: (Filename relativePathOf: 'c:\1\11\a🐬b.txt' to: 'c:\1\') equals: '11\a🐬b.txt'.
	self assert: (Filename relativePathOf: 'c:\1\11\a🐬b.txt' to: 'c:\2\21\')
		equals: '..\..\1\11\a🐬b.txt'.
	self assert: (Filename relativePathOf: 'c:\1\11\a🐬b.txt' to: 'c:\2\21')
		equals: '..\1\11\a🐬b.txt'.
	self assert: (Filename relativePathOf: 'c:\1\11\a🐬b.txt' to: 'c:\2\21.txt')
		equals: '..\1\11\a🐬b.txt'.

	"Example from MS IMoniker documentation"
	self assert: (Filename relativePathOf: 'c:\projects\secret\art\pict1.bmp'
				to: 'c:\projects\secret\docs\chap1.txt')
		equals: '..\art\pict1.bmp'.
	self assert: (Filename relativePathOf: 'c:\projects\secret\docs\chap1.txt'
				to: 'c:\projects\secret\art\pict1.bmp')
		equals: '..\docs\chap1.txt'.
	"A common type of useage in Dolphin (image relative path)"
	self assert: (Filename
				relativePathOf: 'd:\object arts\dev\dolphin5\Packages\Dolphin\Database\Database Connection.pax.pac'
				to: 'd:\object arts\dev\dolphin5\')
		equals: 'Packages\Dolphin\Database\Database Connection.pax.pac'.
	"Non-canonical path with redundant components - note result is not canonical either"
	self
		assert: (Filename fullPathOf: (Filename
						relativePathOf: 'd:\dummy\..\object arts\dev\dummy\..\dolphin5\Packages\Dolphin\Database\Database Connection.pax'
						to: 'd:\object arts\dev\dolphin5\')
				relativeTo: 'd:\object arts\dev\dolphin5\')
		equals: 'd:\object arts\dev\dolphin5\Packages\Dolphin\Database\Database Connection.pax'.

	"Already a relative path (therefore fails and answers first argument)"
	self assert: (Filename relativePathOf: 'Packages\Dolphin\Database\Database Connection.pax'
				to: 'd:\object arts\dev\dolphin5\')
		equals: 'Packages\Dolphin\Database\Database Connection.pax'.
	self assert: (Filename relativePathOf: '.\Packages\Dolphin\Database\Database Connection.pax'
				to: 'd:\object arts\dev\dolphin5\')
		equals: 'Packages\Dolphin\Database\Database Connection.pax'.
	self
		assert: (Filename relativePathOf: '..\dolphin5\Packages\Dolphin\Database\Database Connection.pax'
				to: 'd:\object arts\dev\dolphin5\')
		equals: '..\dolphin5\Packages\Dolphin\Database\Database Connection.pax'!

testCommonPrefixOfAnd
	self
		assert: ((Filename commonPrefixOf: OS.Kernel32 moduleFileName and: OS.User32 moduleFileName)
				sameAs: SessionManager current systemDirectory).
	self
		assert: (Filename commonPrefixOf: 'D:\dev\Dolphin\DolphinVM7.DLL' and: 'C:\dev\Dolphin\DolphinVM7.DLL')
				isEmpty!

testComposePath
	"Test File class>>composePath:subPath:"

	"Mainstream cases"

	self assert: (Filename composePath: 'd:\£oo\bar\' subPath: 'a🐬b\baz.txt')
		equals: 'd:\£oo\bar\a🐬b\baz.txt'.
	self assert: (Filename composePath: '\\?\d:\£oo\bar\' subPath: 'a🐬b\baz.txt')
		equals: 'd:\£oo\bar\a🐬b\baz.txt'.
	"Empty base path"
	self assert: (Filename composePath: '' subPath: '🐬.txt') equals: '🐬.txt'.
	"Empty sub path"
	self assert: (Filename composePath: 'c:\£oo\bar.txt' subPath: '') equals: 'c:\£oo\bar.txt'.
	"Both parts empty - the Windows PathCombine functions are documented to do this. Doesn't seem consistent with earlier empty base path case."
	self assert: (Filename composePath: '' subPath: '') equals: '\'.
	"Similar case that doesn't seem right either"
	self assert: (Filename composePath: '£oo🐬bar' subPath: '..') equals: '\'.

	".. and . components"
	self assert: (Filename composePath: 'C:\£oo\bar\a£\..\.' subPath: '..\🐬.txt')
		equals: 'C:\£oo\🐬.txt'.
	self assert: (Filename composePath: '.' subPath: '🐬-🐬.txt') equals: '🐬-🐬.txt'.
	self assert: (Filename composePath: '🐬-🐬.txt' subPath: '.') equals: '🐬-🐬.txt'.
	self assert: (Filename composePath: 'c:' subPath: '.') equals: 'c:\'.
	self assert: (Filename composePath: '.' subPath: 'e:') equals: 'e:\'.

	"Cases where the result is (one) longer than the sum of the lengths of the two parts"
	self assert: (Filename composePath: 'c:' subPath: '🐬-🐬.txt') equals: 'c:\🐬-🐬.txt'.
	"PathAllocCombine behaves differently here than the old PathCombine function - it doesn't append a backslash, which wasn't really correct anyway."
	self assert: (Filename composePath: 'd:' subPath: '') equals: 'd:'.

	"MAX_PATH"
	self assert: (Filename composePath: 'c:' subPath: (String new: MAX_PATH - 4 withAll: $a))
		equals: 'c:\' , (String new: MAX_PATH - 4 withAll: $a).

	"MAX_PATH+1 - Path*Combine prepends the long path prefix, \\?\"
	self assert: (Filename composePath: 'c:' subPath: (String new: MAX_PATH - 3 withAll: $a))
		equals: self longPathPrefix , 'c:\' , (String new: MAX_PATH - 3 withAll: $a).
	self assert: (Filename composePath: '\\?\c:' subPath: (String new: MAX_PATH - 3 withAll: $a))
		equals: self longPathPrefix , 'c:\' , (String new: MAX_PATH - 3 withAll: $a)!

testFullPathOf
	| longPath longFilename |
	self assert: (Filename fullPathOf: 'Dolphin') equals: File workingDirectory , 'Dolphin'.
	self assert: (Filename fullPathOf: '.\Dolphin') equals: File workingDirectory , 'Dolphin'.
	"With extended characters"
	self assert: (Filename fullPathOf: 'a🐬.£b') equals: File workingDirectory , 'a🐬.£b'.
	"An odd case where the first call to GetFullPath (to request the buffer size) returns space for two extra chars, presumably the '.\', but returns the correct size when actually invoked with a buffer."
	self assert: (Filename fullPathOf: '.\Dolphin') equals: File workingDirectory , 'Dolphin'.
	"Exactly MAX_PATH"
	longFilename := String new: MAX_PATH - File workingDirectory size withAll: $x.
	longPath := Filename fullPathOf: longFilename.
	self assert: longPath size equals: MAX_PATH.
	self assert: longPath equals: File workingDirectory , longFilename.
	"MAX_PATH + 1"
	longFilename := String new: MAX_PATH - File workingDirectory size + 1 withAll: $y.
	longPath := Filename fullPathOf: longFilename.
	self assert: longPath size equals: MAX_PATH + 1.
	self assert: longPath equals: File workingDirectory , longFilename.
	"Very long absolute path in long format"
	longPath := String writeStream.
	longPath nextPutAll: '\\?'.
	20 timesRepeat: [longPath nextPutAll: '\abcdefghijklmnopqrstuvwxyz'].
	longPath := longPath contents.
	self assert: longPath size > MAX_PATH.
	self assert: (Filename fullPathOf: longPath) equals: longPath!

testIsRelativePath
	#('c:\' '\\?\c:\' 'c:\.' 'c:\foo\..' '\\?\c:\foo\..' '\' 'c:/' 'c:\blah.txt' 'c:\foo\..\bar.txt')
		do: [:each | self deny: (Filename isRelativePath: each)].
	#('.' '..' '.\' '..\' 'blah' 'blah.txt' 'foo\bar' 'foo\bar.txt' '.\foo' '.\foo\bar' '.\foo.txt' '.\foo\bar.txt' '..\foo' '..\foo\bar.txt' 'c:' '-' '-:\')
		do: [:each | self assert: (Filename isRelativePath: each)].
	"Some boundary cases"
	self assert: (Filename isRelativePath: ':').
	self assert: (Filename isRelativePath: nil).
	self assert: (Filename isRelativePath: '').
	"PathIsRelative API also doesn't recognise long path prefix, but just treats as if a root path. This appears consistent with the OpenFile API."
	self deny: (Filename isRelativePath: '\\?\foo.txt')!

testIsRelativePathForwardSlash
	self deny: (Filename isRelativePath: '/').
	self deny: (Filename isRelativePath: 'c:/').
	self deny: (Filename isRelativePath: 'D:/').
	self assert: (Filename isRelativePath: 'a/').
	self assert: (Filename isRelativePath: './')!

testIsRelativePathOnDrive
	"There is a current directory for every drive, so paths that start with a drive can still be relative, See [Fully Qualified vs. Relative Paths](https://learn.microsoft.com/en-us/windows/win32/fileio/naming-a-file#fully-qualified-vs-relative-paths)"

	self assert: (Filename isRelativePath: 'c:foo.txt').
	self assert: (Filename isRelativePath: 'c:foo\bar')!

testIsRootPath
	#('\' 'c:\' '\\?\c:\' '\\server\share' '\\server' '\\' '\\?\UNC\' '\\?\UNC\server\share' '\\?\UNC\server')
		do: [:each | self assert: (Filename isRootPath: each)].
	#(nil '' 'c:' 'c:\foo' '\foo' 'c:\foo\..' '\\server\' '\\server\share\' '\\server\share\file' '\\?\UNC\server\share\' '\\?\c:' '\\?\c:\foo' '\\?\c:\foo\..' '/' 'c:\blah.txt' '.\blah.txt' 'con:\')
		do: [:each | self deny: (Filename isRootPath: each)].
	"Note that the Unix directory separator is not accepted (a Windows API is used)"
	self deny: (Filename isRootPath: 'c:/').
	"This is really a root path, but uncanonicalized"
	self deny: (Filename isRootPath: 'c:\.').
	"Ditto"
	self deny: (Filename isRootPath: 'c:\foo\..')!

testMakePath
	| filename split |
	self assert: (Filename makePath: #('c:' 'a/b 2/c/' 'a file' '.anextension'))
		equals: 'c:a/b 2/c/a file.anextension'.
	self assert: (Filename makePath: #('c' '\dir' 'file' 'txt')) equals: 'c:\dir\file.txt'.
	self assert: (Filename makePath: #(nil nil nil nil)) equals: ''.
	self assert: (Filename makePath: #('' '' '' '')) equals: ''.
	self assert: (Filename makePath: #('c' '' '' '')) equals: 'c:'.
	self assert: (Filename makePath: #('c' 'abc' '' '')) equals: 'c:abc\'.
	self assert: (Filename makePath: #('c' '' 'file' '')) equals: 'c:file'.
	self assert: (Filename makePath: #('c' '' '' 'txt')) equals: 'c:.txt'.
	self assert: (Filename makePath: #('c' '' 'a 🐬 c' 'txt')) equals: 'c:a 🐬 c.txt'.
	self assert: (Filename makePath: #('c' 'a/b' 'file' '')) equals: 'c:a/b\file'.
	self assert: (Filename makePath: #('c' '\' '' '')) equals: 'c:\'.
	self assert: (Filename makePath: #('' 'a\b' '' '')) equals: 'a\b\'.
	self assert: (Filename makePath: #('' '' 'file' '')) equals: 'file'.
	self assert: (Filename makePath: #('' '' '' 'txt')) equals: '.txt'.
	"Shouldn't matter if the filename is notionally too long"
	filename := String writeStream.
	self printFilenameOfLength: self maxFname * 2 on: filename.
	filename := filename contents.
	split := filename subStrings: $..
	self assert: (Filename makePath: { nil. nil. split first. split second }) equals: filename!

testRemoveExtension
	| path |
	self assert: (Filename removeExtension: 'a.') equals: 'a'.
	self assert: (Filename removeExtension: '.exe') equals: ''.
	self assert: (Filename removeExtension: '.') equals: ''.
	self assert: (Filename removeExtension: '') equals: ''.
	self assert: (Filename removeExtension: '1234.123🐬.exe') equals: '1234.123🐬'.
	self assert: (Filename removeExtension: '1234.1234.+') equals: '1234.1234'.
	self assert: (Filename removeExtension: 'a.b\c') equals: 'a.b\c'.
	self assert: (Filename removeExtension: 'a.b\') equals: 'a.b\'.
	self assert: (Filename removeExtension: 'c:/a/b.txt') equals: 'c:/a/b'.
	path := String writeStream.
	path nextPutAll: 'c:\'.
	self printFilenameOfLength: self maxFname on: path.
	path := path contents.
	self assert: (Filename removeExtension: path) equals: (path subStrings: $.) first.
	"Doesn't matter if the path is notionally too long"
	path := self buildTestPathOfLength: MAX_PATH * 2.
	self assert: (Filename removeExtension: path) equals: (path subStrings: $.) first!

testRemovePathDelimiter
	self assert: (Filename removePathDelimiter: '') equals: ''.
	self assert: (Filename removePathDelimiter: '/') equals: ''.
	self assert: (Filename removePathDelimiter: '//') equals: '/'.
	self assert: (Filename removePathDelimiter: '\') equals: ''.
	self assert: (Filename removePathDelimiter: '\/') equals: '\'.
	self assert: (Filename removePathDelimiter: '.') equals: '.'.
	self assert: (Filename removePathDelimiter: './') equals: '.'.
	self assert: (Filename removePathDelimiter: 'c:') equals: 'c:'.
	self assert: (Filename removePathDelimiter: 'c:\') equals: 'c:'.
	self assert: (Filename removePathDelimiter: 'c:\blah.txt') equals: 'c:\blah.txt'.
	"Test with non-ASCII chars and characters outside the BMP"
	#('c:\a🐬' 'c:\a🐬b' 'c:\a£' 'c:\a£b') do: 
			[:each |
			self assert: (Filename removePathDelimiter: each) equals: each.
			self assert: (Filename removePathDelimiter: each , '\') equals: each]!

testSplitDriveFrom
	self should: [Filename splitDriveFrom: nil] raise: Error.
	self assert: (Filename splitDriveFrom: 'c:\a\a2/b.txt') equals: 'c:'.
	self assert: (Filename splitDriveFrom: 'a\🐬.txt') equals: ''.
	self assert: (Filename splitDriveFrom: 'b.txt') equals: ''.
	self assert: (Filename splitDriveFrom: '.txt') equals: ''.
	self assert: (Filename splitDriveFrom: '.') equals: ''.
	self assert: (Filename splitDriveFrom: '') equals: ''.
	self assert: (Filename splitDriveFrom: 'c:/a b\c d.txt') equals: 'c:'.
	self assert: (Filename splitDriveFrom: 'd:\') equals: 'd:'.
	self assert: (Filename splitDriveFrom: 'e:') equals: 'e:'.
	self assert: (Filename splitDriveFrom: 'cons:') equals: ''!

testSplitExtensionFrom
	| path ext unicode |
	unicode := $\x1F595 asUtf16String , '2'.
	self assert: (Filename splitExtensionFrom: 'c:\a\a2/b.' , unicode) equals: unicode.
	self assert: (Filename splitExtensionFrom: 'a\b.txt') equals: 'txt'.
	self assert: (Filename splitExtensionFrom: 'b.a🐬£') equals: 'a🐬£'.
	self assert: (Filename splitExtensionFrom: 'b.') equals: ''.
	self assert: (Filename splitExtensionFrom: '.txt') equals: 'txt'.
	self assert: (Filename splitExtensionFrom: '.') equals: ''.
	self assert: (Filename splitExtensionFrom: '') equals: ''.
	self assert: (Filename splitExtensionFrom: 'c:\a\b\') equals: ''.
	self assert: (Filename splitExtensionFrom: 'c:/a b\c d.a🐬b') equals: 'a🐬b'.
	self assert: (Filename splitExtensionFrom: '1234.1234.exe') equals: 'exe'.
	self assert: (Filename splitExtensionFrom: 'a.b\c') equals: ''.
	self assert: (Filename splitExtensionFrom: 'a.b\') equals: ''.
	path := self buildTestPathOfLength: MAX_PATH.
	self assert: (Filename splitExtensionFrom: path) equals: 'txt'.
	"The CRT functions works even if the path is too long because we ignore everything but the extension"
	path := path , 'x'.
	self assert: (Filename splitExtensionFrom: path) equals: 'txtx'.
	path := self buildTestPathOfLength: MAX_PATH * 2.
	self assert: (Filename splitExtensionFrom: path) equals: 'txt'.
	"Try a very filename with very long extension (of max length)."
	path := String writeStream.
	self printFilenameOfLength: self maxFname * 2 on: path.
	path := path contents.
	ext := (path subStrings: $.) last.
	self assert: (Filename splitExtensionFrom: path) equals: ext.
	"Works even if extension is notionally too large"
	path := path , ext.
	self assert: (Filename splitExtensionFrom: path) equals: ext , ext!

testSplitFilenameFrom
	| path unicode |
	self should: [Filename splitFilenameFrom: nil] raise: Error.
	self assert: (Filename splitFilenameFrom: '.') equals: '.'.
	self assert: (Filename splitFilenameFrom: 'c:\a\a2/b.txt') equals: 'b.txt'.
	self assert: (Filename splitFilenameFrom: 'a£b\🐬.txt') equals: '🐬.txt'.
	self assert: (Filename splitFilenameFrom: 'b.txt') equals: 'b.txt'.
	self assert: (Filename splitFilenameFrom: 'b.') equals: 'b.'.
	self assert: (Filename splitFilenameFrom: '.txt') equals: '.txt'.
	self assert: (Filename splitFilenameFrom: '') equals: ''.
	self assert: (Filename splitFilenameFrom: 'c:\a\b\') equals: ''.
	unicode := 'c ' , $\x1F595 asUtf16String , ' d.txt'.
	self assert: (Filename splitFilenameFrom: 'c:/a b\' , unicode) equals: unicode.
	self assert: (Filename splitFilenameFrom: '1234.1234.exe') equals: '1234.1234.exe'.
	self assert: (Filename splitFilenameFrom: 'a.b\c') equals: 'c'.
	self assert: (Filename splitFilenameFrom: 'a.b\') equals: ''.
	path := self buildTestPathOfLength: MAX_PATH.
	self assert: (Filename splitFilenameFrom: path) equals: (path subStrings: $\) last.
	"Try a very long filename (> max length), this will still work."
	path := String writeStream.
	path nextPutAll: 'c:\'.
	self printFilenameOfLength: self maxFname * 2 on: path.
	path := path contents.
	self assert: (Filename splitFilenameFrom: path) equals: (path copyFrom: 4)!

testSplitPathFrom
	| path |
	self should: [Filename splitPathFrom: nil] raise: Error.
	self assert: (Filename splitPathFrom: '.') equals: ''.
	self assert: (Filename splitPathFrom: 'c:\a\a2/b.txt') equals: 'c:\a\a2/'.
	self assert: (Filename splitPathFrom: 'c:\a\b.txt') equals: 'c:\a\'.
	self assert: (Filename splitPathFrom: 'c:\a\b\') equals: 'c:\a\b\'.
	self assert: (Filename splitPathFrom: 'c:\b.txt') equals: 'c:\'.
	self assert: (Filename splitPathFrom: 'c:\') equals: 'c:\'.
	self assert: (Filename splitPathFrom: 'c:') equals: 'c:'.
	self assert: (Filename splitPathFrom: 'a\b.txt') equals: 'a\'.
	self assert: (Filename splitPathFrom: 'b.txt') equals: ''.
	self assert: (Filename splitPathFrom: 'b.') equals: ''.
	self assert: (Filename splitPathFrom: '.txt') equals: ''.
	self assert: (Filename splitPathFrom: '') equals: ''.
	self assert: (Filename splitPathFrom: 'c:\a\b\') equals: 'c:\a\b\'.
	self assert: (Filename splitPathFrom: 'c:/a b\c 🖕d.txt') equals: 'c:/a b\'.
	self assert: (Filename splitPathFrom: '1234.1234.exe') equals: ''.
	self assert: (Filename splitPathFrom: 'a.b\c') equals: 'a.b\'.
	self assert: (Filename splitPathFrom: 'a.b\') equals: 'a.b\'.
	path := self buildTestPathOfLength: MAX_PATH.
	self assert: (Filename splitPathFrom: path)
		equals: ($\ join: (path subStrings: $\) allButLast) , '\'.
	"Try a very long filename (> max length), this will still work."
	path := String writeStream.
	path nextPutAll: 'c:\'.
	self printFilenameOfLength: self maxFname * 2 on: path.
	path nextPutAll: '/a.txt'.
	path := path contents.
	self assert: (Filename splitPathFrom: path) equals: (path upTo: $/) , '/'!

testSplitStemFrom
	| path |
	self assert: (Filename splitStemFrom: '.') equals: ''.
	self assert: (Filename splitStemFrom: 'c:\a\a🐬/b.txt') equals: 'b'.
	self assert: (Filename splitStemFrom: 'a\b.txt') equals: 'b'.
	self assert: (Filename splitStemFrom: 'b.txt') equals: 'b'.
	self assert: (Filename splitStemFrom: 'a🐬.txt') equals: 'a🐬'.
	self assert: (Filename splitStemFrom: 'b.') equals: 'b'.
	self assert: (Filename splitStemFrom: '.txt') equals: ''.
	self assert: (Filename splitStemFrom: '') equals: ''.
	self assert: (Filename splitStemFrom: '\') equals: ''.
	self assert: (Filename splitStemFrom: 'c:\') equals: ''.
	self assert: (Filename splitStemFrom: 'c:\.txt') equals: ''.
	self assert: (Filename splitStemFrom: 'c:\a\b\') equals: ''.
	self assert: (Filename splitStemFrom: 'c:/a b\c 🐬.txt') equals: 'c 🐬'.
	self assert: (Filename splitStemFrom: '1234.1234.exe') equals: '1234.1234'.
	self assert: (Filename splitStemFrom: 'a.b\c') equals: 'c'.
	self assert: (Filename splitStemFrom: 'a.b\') equals: ''.
	path := self buildTestPathOfLength: MAX_PATH.
	self assert: (Filename splitStemFrom: path) equals: ((path subStrings: $\) last upTo: $.).
	"Try a very long filename (> max length), this will still work."
	path := String writeStream.
	path nextPutAll: 'c:\'.
	self printFilenameOfLength: self maxFname * 2 on: path.
	path := path contents.
	self assert: (Filename splitStemFrom: path) equals: ((path copyFrom: 4) upTo: $.)! !

!Core.Tests.FilenameTest categoriesForMethods!
buildTestPathOfLength:!helpers!private! !
longFilenamesEnabled!helpers!private! !
longPathPrefix!helpers!private! !
maxFname!constants!private! !
printFilenameOfLength:on:!helpers!private! !
testCanonicalizePath!public!unit tests! !
testClassAppendPathSeparator!public!unit tests! !
testClassDefaultExtension!public!unit tests! !
testClassPathExtension!public!unit tests! !
testClassRelativePathOfTo!public!unit tests! !
testCommonPrefixOfAnd!public!unit tests! !
testComposePath!public!unit tests! !
testFullPathOf!public!unit tests! !
testIsRelativePath!public!unit tests! !
testIsRelativePathForwardSlash!public!unit tests! !
testIsRelativePathOnDrive!public!unit tests! !
testIsRootPath!public!unit tests! !
testMakePath!public!unit tests! !
testRemoveExtension!public!unit tests! !
testRemovePathDelimiter!public!unit tests! !
testSplitDriveFrom!public!unit tests! !
testSplitExtensionFrom!public!unit tests! !
testSplitFilenameFrom!public!unit tests! !
testSplitPathFrom!public!unit tests! !
testSplitStemFrom!public!unit tests! !
!

