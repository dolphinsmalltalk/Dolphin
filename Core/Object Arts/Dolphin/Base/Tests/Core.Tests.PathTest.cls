"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.PathTest'
	instanceVariableNames: 'tempDir'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants} #{OS.CRTLibrary} #{OS} #{OS.Win32Error})
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.PathTest guid: (Core.GUID fromString: '{ec8f9547-fbd4-4905-9944-c6614ee9cc1b}')!

Core.Tests.PathTest comment: ''!

!Core.Tests.PathTest methodsFor!

activeLongPathPrefix
	^OS.PathCch isLongPathAware ifTrue: [''] ifFalse: [OS.KernelLibrary.LongPathPrefix]!

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

createTestDirectories
	| dir |
	tempDir := Path newTemporaryDirectory.
	(tempDir \ 'FileTest1\EmptyLeaf\') createDirectoryPath.
	dir := tempDir \ 'FileTest1\LeafWithFile\'.
	dir createDirectoryPath.
	(File write: dir \ 'Blah.txt')
		write: 'Blah';
		close.
	dir := tempDir \ 'FileTest1\LeafWithFiles\'.
	dir createDirectoryPath.
	(File write: dir \ 'Blah1.txt')
		write: 'Blah';
		close.
	(File write: dir \ 'Blah2.txt')
		write: 'Blah blah';
		close.
	(tempDir \ 'FileTest1\BranchWithEmptyLeaf\EmptyLeaf1\') createDirectoryPath.
	dir := tempDir \ 'FileTest1\BranchWithEmptyLeaves\'.
	(dir \ 'EmptyLeaf1\') createDirectoryPath.
	(dir \ 'EmptyLeaf2\') createDirectory.
	dir := tempDir \ 'FileTest1\BranchWithEmptyLeafAndFile\'.
	(dir \ '\EmptyLeaf1\') createDirectoryPath.
	(File write: dir \ 'blah.txt')
		write: 'Blah blah blah';
		close.
	dir := tempDir \ 'FileTest1\BranchWithEmptyLeafAndFiles\'.
	(dir \ '\EmptyLeaf1\') createDirectoryPath.
	(File write: dir \ 'blah1.txt')
		write: 'Blah blah blah';
		close.
	(File write: dir \ 'blah2.txt')
		write: 'Blah blah blah';
		close.
	dir := tempDir \ 'FileTest1\BranchWithEmptyLeavesAndFile\'.
	(dir \ '\EmptyLeaf1\') createDirectoryPath.
	(dir \ '\EmptyLeaf2\') createDirectoryPath.
	(File write: dir \ 'blah.txt')
		write: 'Blah blah blah';
		close.
	dir := tempDir \ 'FileTest1\BranchWithEmptyLeavesAndFiles\'.
	(dir \ '\EmptyLeaf1\') createDirectoryPath.
	(dir \ '\EmptyLeaf2\') createDirectoryPath.
	(File write: dir \ 'blah1.txt')
		write: 'Blah blah blah';
		close.
	(File write: dir \ 'blah2.txt')
		write: 'Blah blah blah';
		close.
	dir := tempDir \ 'FileTest1\BranchWithLeafWithFile\'.
	dir createDirectoryPath.
	(dir \ 'LeafWithFile\') createDirectory.
	(File write: dir \ '\LeafWithFile\blah.txt')
		write: 'Blah blah blah';
		close.
	dir := tempDir \ 'FileTest1\BranchWithLeafWithFiles🐬\'.
	dir createDirectoryPath.
	(dir \ 'LeafWithFiles\') createDirectory.
	(File write: dir \ '\LeafWithFiles\a🐬b.txt')
		write: 'Blah blah blah';
		close.
	(File write: dir \ '\LeafWithFiles\a£b.txt')
		write: 'Blah blah blah';
		close!

deleteDirectory: aPath
	self assert: aPath isDirectory.
	aPath delete.
	self deny: aPath exists!

maxFname
	^_MAX_FNAME!

printFilenameOfLength: anInteger on: path
	(1 to: anInteger) do: [:i | path nextPut: (Character codePoint: $a codePoint + (i % 10))].
	path nextPut: $..
	(1 to: _MAX_EXT - 1) do: [:i | path nextPut: (Character codePoint: $a codePoint + (i % 10))]!

relativePathOf: a to: b
	^(a asPath relativeTo: b) asString!

removeDirectory: aPath
	self assert: aPath isDirectory.
	aPath removeDirectory.
	self deny: aPath exists!

tearDown
	self safeDeleteDir: tempDir.
	super tearDown!

testAppend
	"Mainstream cases"

	self assert: 'd:\£oo\bar\' asPath \ 'a🐬b\baz.txt' equals: 'd:\£oo\bar\a🐬b\baz.txt' asPath.
	self assert: '\\?\d:\£oo\bar\' asPath \ 'a🐬b\baz.txt'
		equals: '\\?\d:\£oo\bar\a🐬b\baz.txt' asPath.
	"Empty base path"
	self assert: '' asPath \ '🐬.txt' equals: '🐬.txt' asPath.
	"Empty sub path"
	self assert: 'c:\£oo\bar.txt' asPath \ '' equals: 'c:\£oo\bar.txt' asPath.
	"Unliked combinedWith:, when appending paths we don't generate a root path if both paths are empty."
	self assert: '' asPath \ '' equals: '' asPath.
	"Relative path navigation should be preserved"
	self assert: '£oo🐬bar' asPath \ '..' equals: '£oo🐬bar\..' asPath.
	self assert: '£oo🐬bar' asPath \ '.' equals: '£oo🐬bar\.' asPath.

	".. and . components"
	self assert: 'C:\£oo\bar\a£\..\.' asPath \ '..\🐬.txt'
		equals: 'C:\£oo\bar\a£\..\.\..\🐬.txt' asPath.
	self assert: '.' asPath \ '🐬-🐬.txt' equals: '.\🐬-🐬.txt' asPath.
	self assert: '🐬-🐬.txt' asPath \ '.' equals: '🐬-🐬.txt\.' asPath.
	self assert: 'c:' asPath \ '.' equals: 'c:\.' asPath.
	self assert: '.' asPath \ 'e:' equals: 'e:' asPath.

	"UNC"
	self assert: '\\a' \ 'b' equals: '\\a\b' asPath.
	self assert: 'c:\a\b.txt' \ '\\a' equals: '\\a' asPath.

	"Cases where the result is (one) longer than the sum of the lengths of the two parts"
	self assert: 'c:' asPath \ '🐬-🐬.txt' equals: 'c:\🐬-🐬.txt' asPath.
	"PathAllocCombine behaves differently here than the old PathCombine function - it doesn't append a backslash, which wasn't really correct anyway."
	self assert: 'd:' asPath \ '' equals: 'd:' asPath.

	"MAX_PATH-1 (MAX_PATH includes null terminator)"
	self assert: 'c:' asPath \ (String new: MAX_PATH - 4 withAll: $a)
		equals: ('c:\' , (String new: MAX_PATH - 4 withAll: $a)) asPath.

	"MAX_PATH - If not long path aware, then long path prefix, \\?\, is prepended"
	self assert: 'c:' asPath \ (String new: MAX_PATH - 3 withAll: $a)
		equals: (self activeLongPathPrefix , 'c:\' , (String new: MAX_PATH - 3 withAll: $a)) asPath.
	self assert: '\\?\c:\' asPath \ (String new: MAX_PATH - 3 withAll: $a)
		equals: ('\\?\c:\' , (String new: MAX_PATH - 3 withAll: $a)) asPath!

testCanonicalized
	"Test File class>>composePath:subPath:"

	"Mainstream case"

	self assert: 'd:\£oo\bar\a🐬b\baz.txt' asPath canonicalized
		equals: 'd:\£oo\bar\a🐬b\baz.txt' asPath.
	"Unecessary long path prefix"
	self assert: '\\?\d:\£oo\bar\a🐬b\baz.txt' asPath canonicalized
		equals: 'd:\£oo\bar\a🐬b\baz.txt' asPath.
	"Empty - inconsistent behaviour, although consistently inconsistent with PathCombine API"
	self assert: '' asPath canonicalized equals: '\' asPath.
	self assert: 'c:' asPath canonicalized equals: 'c:' asPath.

	".. and . components"
	self assert: 'C:\£oo\bar\a£\..\.\..\🐬.txt' asPath canonicalized
		equals: 'C:\£oo\🐬.txt' asPath.
	self assert: '.\🐬-🐬.txt' asPath canonicalized equals: '🐬-🐬.txt' asPath.

	"MAX_PATH - 1 (because MAX_PATH includes null terminator)"
	self assert: ('c:\' , (String new: MAX_PATH - 4 withAll: $a)) asPath canonicalized
		equals: ('c:\' , (String new: MAX_PATH - 4 withAll: $a)) asPath.

	">= MAX_PATH"
	self assert: ('c:\' , (String new: MAX_PATH - 3 withAll: $a)) asPath canonicalized
		equals: (self activeLongPathPrefix , 'c:\' , (String new: MAX_PATH - 3 withAll: $a)) asPath.
	self assert: ('\\?\c:\' , (String new: MAX_PATH - 3 withAll: $a)) asPath canonicalized
		equals: (self activeLongPathPrefix , 'c:\' , (String new: MAX_PATH - 3 withAll: $a)) asPath!

testCombinedWith
	"Combining paths normalizes them"

	"Mainstream cases"

	self assert: ('d:\£oo\bar\' asPath combinedWith: 'a🐬b\baz.txt')
		equals: 'd:\£oo\bar\a🐬b\baz.txt' asPath.
	self assert: ('\\?\d:\£oo\bar\' asPath combinedWith: 'a🐬b\baz.txt')
		equals: 'd:\£oo\bar\a🐬b\baz.txt' asPath.
	"Empty base path"
	self assert: ('' asPath combinedWith: '🐬.txt') equals: '🐬.txt' asPath.
	"Empty sub path"
	self assert: ('c:\£oo\bar.txt' asPath combinedWith: '') equals: 'c:\£oo\bar.txt' asPath.
	"Both parts empty - the Windows PathCombine functions are documented to do this. Doesn't seem consistent with earlier empty base path case."
	self assert: ('' asPath combinedWith: '') equals: '\' asPath.
	"Similar case that doesn't seem right either"
	self assert: ('£oo🐬bar' asPath combinedWith: '..') equals: '\' asPath.

	".. and . components"
	self assert: ('C:\£oo\bar\a£\..\.' asPath combinedWith: '..\🐬.txt')
		equals: 'C:\£oo\🐬.txt' asPath.
	self assert: ('.' asPath combinedWith: '🐬-🐬.txt') equals: '🐬-🐬.txt' asPath.
	self assert: ('🐬-🐬.txt' asPath combinedWith: '.') equals: '🐬-🐬.txt' asPath.
	self assert: ('c:' asPath combinedWith: '.') equals: 'c:\' asPath.
	self assert: ('.' asPath combinedWith: 'e:') equals: 'e:\' asPath.

	"Cases where the result is (one) longer than the sum of the lengths of the two parts"
	self assert: ('c:' asPath combinedWith: '🐬-🐬.txt') equals: 'c:\🐬-🐬.txt' asPath.
	"PathAllocCombine behaves differently here than the old PathCombine function - it doesn't append a backslash, which wasn't really correct anyway."
	self assert: ('d:' asPath combinedWith: '') equals: 'd:' asPath.

	"MAX_PATH"
	self assert: ('c:' asPath combinedWith: (String new: MAX_PATH - 4 withAll: $a))
		equals: ('c:\' , (String new: MAX_PATH - 4 withAll: $a)) asPath.

	"MAX_PATH+1 - Path*Combine prepends the long path prefix, \\?\"
	self assert: ('c:' asPath combinedWith: (String new: MAX_PATH - 3 withAll: $a))
		equals: (self activeLongPathPrefix , 'c:\' , (String new: MAX_PATH - 3 withAll: $a)) asPath.
	self assert: ('\\?\c:' asPath combinedWith: (String new: MAX_PATH - 3 withAll: $a))
		equals: (self activeLongPathPrefix , 'c:\' , (String new: MAX_PATH - 3 withAll: $a)) asPath!

testCommonPrefixWith
	self assert: (Kernel32 moduleFileName asPath commonPrefixWith: User32 moduleFileName)
		equals: SessionManager current systemDirectory asPath.
	self
		assert: ('D:\dev\Dolphin\DolphinVM7.DLL' asPath commonPrefixWith: 'C:\dev\Dolphin\DolphinVM7.DLL')
				isEmpty!

testComparing
	| path1 path2 |
	path1 := 'c:\a\🐬' asPath.
	path2 := 'C:\A\🐬' asPath.
	self assert: path1 equals: path2.
	self assert: path2 equals: path1.
	self assert: path1 hash equals: path2 hash.
	self assert: path1 <=> path2 equals: 0.
	self assert: path2 <=> path1 equals: 0.
	self assert: path2 <= path1.
	self assert: path1 <= path2.
	path2 := path2 withSeparator.
	self deny: path1 equals: path2.
	self deny: path2 equals: path1.
	self deny: path1 hash equals: path2 hash.
	self assert: path1 <=> path2 equals: -1.
	self assert: path2 <=> path1 equals: 1.
	self deny: path2 <= path1.
	self assert: path1 <= path2.

	
	!

testCreateDirectory
	| subDir |
	tempDir := Path newTemporaryDirectory.
	self assert: tempDir isDirectory.
	self deny: tempDir createDirectory.
	{
		String new: 248 - tempDir size - 2 withAll: $a.
		String new: 248 withAll: $b.
		String new: 248 - tempDir size - 1 withAll: $c
	} do: 
				[:each |
				subDir := tempDir \ each.
				self assert: subDir withSeparator createDirectory.
				self assert: subDir isDirectory]!

testCreateDirectoryPath
	| path |
	"It is not an error to attempt to create directory paths that already exist"
	#('c:' 'c:\' 'c:\windows' 'c:\windows\' 'c:\windows\system32' 'c:\windows\system32\')
		do: [:each | self deny: each asPath createDirectoryPath].
	"We want the operation to fail if the path refers to an existing file, as obviously we can't use this as a directory."
	self
		should: [VM fileName asPath withSeparator createDirectoryPath]
		raise: Win32Error
		matching: [:ex | ex statusCode == ERROR_FILE_EXISTS].
	tempDir := Path newTemporaryDirectory.
	path := tempDir \ 'one\'.
	path createDirectoryPath.
	self assert: path isDirectory.
	path := tempDir \ 'one\two\three\'.
	path createDirectoryPath.
	self assert: path isDirectory.
	path := tempDir \ (String new: MaxDir - tempDir size withAll: $a).
	self assert: path size equals: MaxDir.
	self deny: path isLong.
	path withSeparator createDirectoryPath.
	self assert: path isDirectory.
	path := tempDir \ (String new: MaxDir + 1 - tempDir size withAll: $b).
	self assert: path size equals: MaxDir + 1.
	self deny: path isLong.
	path withSeparator createDirectoryPath.
	self assert: path isDirectory.
	path := tempDir \ (String new: 255 - tempDir size withAll: $b).
	self assert: path size equals: 255.
	self deny: path isLong.
	path withSeparator createDirectoryPath.
	self assert: path isDirectory.
	path := tempDir \ (String new: MAX_PATH - tempDir size - 1 withAll: $c).
	self assert: path size equals: MAX_PATH - 1.
	self deny: path isLong.
	path withSeparator createDirectoryPath.
	self assert: path isDirectory.
	path := tempDir \ ('long\' , (String new: 250 withAll: $£)).
	self assert: path isLong equals: PathCch isLongPathAware not.
	path withSeparator createDirectoryPath.
	self assert: path isDirectory!

testCreateTemporaryDirectory
	| tempDir2 |
	tempDir := Path newTemporaryDirectory.
	tempDir2 := Path newTemporaryDirectory.
	[self deny: tempDir equals: tempDir2] ensure: [tempDir2 delete]!

testDeleteDirectory
	| testDir |
	self createTestDirectories.
	testDir := tempDir \ 'FileTest1'.
	self deleteDirectory: testDir \ 'EmptyLeaf\'.
	self deleteDirectory: testDir \ 'BranchWithEmptyLeaf\EmptyLeaf1'.
	self deleteDirectory: testDir \ 'BranchWithEmptyLeaves\'.
	self deleteDirectory: testDir \ 'LeafWithFile\'.
	self deleteDirectory: testDir \ 'BranchWithEmptyLeafAndFile\'.
	self deleteDirectory: testDir \ 'BranchWithEmptyLeafAndFiles\'.
	self deleteDirectory: testDir \ 'BranchWithEmptyLeavesAndFile\'.
	self deleteDirectory: testDir \ 'BranchWithEmptyLeavesAndFiles\'.
	self deleteDirectory: testDir \ 'BranchWithLeafWithFile\'.
	self deleteDirectory: testDir \ 'BranchWithLeafWithFiles🐬\'!

testDeleteDirectory2
	self createTestDirectories.
	self deleteDirectory: tempDir.
	self
		should: [tempDir deleteDirectory]
		raise: Win32Error
		matching: [:ex | ex statusCode = ERROR_PATH_NOT_FOUND]!

testDirectory
	| path empty |
	self should: [Path new directoryName] raise: Error.
	self assert: '.' asPath directory equals: '' asPath.
	self assert: 'c:\a\a2/b.txt' asPath directory equals: 'c:\a\a2/' asPath.
	self assert: 'c:/a 🐬\c 🖕d.txt' asPath directory equals: 'c:/a 🐬\' asPath.
	self assert: 'c:\a\b.txt' asPath directory equals: 'c:\a\' asPath.
	self assert: 'a.b\c' asPath directory equals: 'a.b\' asPath.
	self assert: 'c:\b.txt' asPath directory equals: 'c:\' asPath.
	self assert: 'a\b.txt' asPath directory equals: 'a\' asPath.
	#('c:\a\b\' 'C:\' 'c:' 'a.b\') do: 
			[:each |
			path := each asPath.
			self assert: path directory identicalTo: path].
	empty := '' asPath.
	#('b.txt' 'b.' '.txt' '' '1234.1234.exe')
		do: [:each | self assert: each asPath directory equals: empty].
	path := self buildTestPathOfLength: MAX_PATH.
	self assert: path asPath directory
		equals: (($\ join: (path subStrings: $\) allButLast) , '\') asPath.
	"Try a very long filename (> max length), this will still work."
	path := String writeStream.
	path nextPutAll: 'c:\'.
	self printFilenameOfLength: self maxFname * 2 on: path.
	path nextPutAll: '/a.txt'.
	path := path contents asPath.
	self assert: path directory equals: ((path asString upTo: $/) , '/') asPath!

testDirectoryName
	| path |
	self should: [Path new directoryName] raise: Error.
	self assert: '.' asPath directoryName equals: ''.
	self assert: 'c:\a\a2/b.txt' asPath directoryName equals: 'c:\a\a2/'.
	self assert: 'c:\a\b.txt' asPath directoryName equals: 'c:\a\'.
	self assert: 'c:\b.txt' asPath directoryName equals: 'c:\'.
	self assert: 'a\b.txt' asPath directoryName equals: 'a\'.
	self assert: 'a.b\c' asPath directoryName equals: 'a.b\'.
	self assert: 'c:\a\b\' asPath directoryName equals: 'c:\a\b\'.
	self assert: 'c:/a b\c 🖕d.txt' asPath directoryName equals: 'c:/a b\'.
	self assert: 'c:\a\b\' asPath directoryName equals: 'c:\a\b\'.
	self assert: 'c:\' asPath directoryName equals: 'c:\'.
	self assert: 'c:' asPath directoryName equals: 'c:'.
	self assert: 'a.b\' asPath directoryName equals: 'a.b\'.
	#('c:\a\b\' 'C:\' 'c:' 'a.b\') do: [:each | self assert: each asPath directoryName equals: each].
	#('b.txt' 'b.' '.txt' '' '1234.1234.exe')
		do: [:each | self assert: each asPath directoryName isEmpty].
	path := self buildTestPathOfLength: MAX_PATH.
	self assert: path asPath directoryName equals: ($\ join: (path subStrings: $\) allButLast) , '\'.
	"Try a very long filename (> max length), this will still work."
	path := String writeStream.
	path nextPutAll: 'c:\'.
	self printFilenameOfLength: self maxFname * 2 on: path.
	path nextPutAll: '/a.txt'.
	path := path contents.
	self assert: path asPath directoryName equals: self activeLongPathPrefix, (path upTo: $/) , '/'!

testDrive
	self assert: 'c:\a\a2/b.txt' asPath drive equals: 'c:'.
	self assert: 'a\🐬.txt' asPath drive equals: ''.
	self assert: 'b.txt' asPath drive equals: ''.
	self assert: '.txt' asPath drive equals: ''.
	self assert: '.' asPath drive equals: ''.
	self assert: '' asPath drive equals: ''.
	self assert: 'c:/a b\c d.txt' asPath drive equals: 'c:'.
	self assert: 'd:\' asPath drive equals: 'd:'.
	self assert: 'e:' asPath drive equals: 'e:'.
	self assert: 'cons:' asPath drive equals: ''.
	self assert: '\\server\d' asPath drive equals: ''.
	"This didn't used to work correctly because it relied on CRT splitpath, which doesn't split out the drive from paths with a long path prefix."
	self assert: '\\?\c:' asPath drive equals: 'c:'!

testExtension
	| path ext unicode |
	unicode := $\x1F595 asUtf16String , '2'.
	self assert: ('c:\a\a2/b.' , unicode) asPath extension equals: unicode.
	self assert: 'a\b.txt' asPath extension equals: 'txt'.
	self assert: 'b.a🐬£' asPath extension equals: 'a🐬£'.
	self assert: 'b.' asPath extension equals: ''.
	self assert: '.txt' asPath extension equals: 'txt'.
	self assert: '.' asPath extension equals: ''.
	self assert: '' asPath extension equals: ''.
	self assert: 'c:\a\b\' asPath extension equals: ''.
	self assert: 'c:/a b\c d.a🐬b' asPath extension equals: 'a🐬b'.
	self assert: '1234.1234.exe' asPath extension equals: 'exe'.
	self assert: 'a.b\c' asPath extension equals: ''.
	self assert: 'a.b\' asPath extension equals: ''.
	path := self buildTestPathOfLength: MAX_PATH.
	self assert: path asPath extension equals: 'txt'.
	"The CRT functions works even if the path is too long because we ignore everything but the extension"
	path := path , 'x'.
	self assert: path asPath extension equals: 'txtx'.
	path := self buildTestPathOfLength: MAX_PATH * 2.
	self assert: path asPath extension equals: 'txt'.
	"Try a very filename with very long extension (of max length)."
	path := String writeStream.
	self printFilenameOfLength: self maxFname * 2 on: path.
	path := path contents.
	ext := (path subStrings: $.) last.
	self assert: path asPath extension equals: ext.
	"Works even if extension is notionally too large"
	path := path , ext.
	self assert: path asPath extension equals: ext , ext!

testFileName
	| path unicode |
	self should: [Path new fileName] raise: Error.
	self assert: '.' asPath fileName equals: '.'.
	self assert: 'c:\a\a2/b.txt' asPath fileName equals: 'b.txt'.
	self assert: 'a£b\🐬.txt' asPath fileName equals: '🐬.txt'.
	self assert: 'b.txt' asPath fileName equals: 'b.txt'.
	self assert: 'b.' asPath fileName equals: 'b.'.
	self assert: '.txt' asPath fileName equals: '.txt'.
	self assert: '' asPath fileName equals: ''.
	self assert: 'c:\a\b\' asPath fileName equals: ''.
	unicode := 'c ' , $\x1F595 asUtf16String , ' d.txt'.
	self assert: ('c:/a b\' , unicode) asPath fileName equals: unicode.
	self assert: '1234.1234.exe' asPath fileName equals: '1234.1234.exe'.
	self assert: 'a.b\c' asPath fileName equals: 'c'.
	self assert: 'a.b\' asPath fileName equals: ''.
	path := self buildTestPathOfLength: MAX_PATH.
	self assert: path asPath fileName equals: (path subStrings: $\) last.
	"Try a very long filename (> max length), this will still work."
	path := String writeStream.
	path nextPutAll: 'c:\'.
	self printFilenameOfLength: self maxFname * 2 on: path.
	path := path contents.
	self assert: path asPath fileName equals: (path copyFrom: 4)!

testFileTimes
	| now file tempFileName |
	now := FILETIME now.
	tempFileName := Path temporary.
	
	[file := File open: tempFileName.
	self assert: file lastWriteTime asInteger >= now asInteger.
	self assert: tempFileName lastWriteTime equals: file lastWriteTime.
	self assert: tempFileName lastAccessTime equals: file lastAccessTime]
			ensure: 
				[file ifNotNil: [file close].
				tempFileName deleteFile]!

testFindFiles
	| found |
	found := Set new.
	FileLocator imageRelative basePath for: '*.' , SessionManager current imageExtension
		do: [:data | found add: data fullPath].
	self assert: (found includes: SessionManager current imageFileName asPath).
	self
		should: [GUID newUnique idlString asPath for: '*.*' do: [:each | self fail: 'Really?']]
		raise: Win32Error
		matching: [:ex | ex statusCode = ERROR_PATH_NOT_FOUND]!

testFindMatching
	| dir |
	self
		should: [(('c:\' , GUID newUnique idlString) \ '*.*') findMatching]
		raise: Win32Error
		matching: [:ex | ex statusCode = Win32Error.ERROR_PATH_NOT_FOUND].
	self createTestDirectories.
	dir := tempDir \ 'FileTest1\LeafWithFiles'.
	self assert: (dir \ '*.txt') findMatching asArray equals: { dir \ 'Blah1.txt'. dir \'Blah2.txt'}.
	dir := tempDir \ 'FileTest1\LeafWithFile'.
	self assert: (dir \ '*.txt') findMatching asArray equals: { dir \ 'Blah.txt'}.
	dir := tempDir \ 'FileTest1\BranchWithEmptyLeaf\EmptyLeaf1'.
	self assert: (dir \ '*.txt') findMatching asArray equals: #()
!

testForDirectories
	| all windir |
	all := OrderedCollection new.
	windir := Path windowsDirectory.
	windir forDirectories: '*.*' do: [:each | all add: each fileName asLowercase].
	self assert: (all includes: 'system32').
	self assert: (all includes: 'system').
	self deny: (all includes: '.').
	self deny: (all includes: '..').
	all do: [:each | self assert: (windir \ each) isDirectory].
	self
		should: [GUID newUnique idlString asPath forDirectories: '*.*' do: [:each | self fail: 'Really?']]
		raise: Win32Error
		matching: [:ex | ex statusCode = ERROR_PATH_NOT_FOUND]!

testFullPath
	| longPath longFilename |
	self assert: 'Dolphin' asPath fullPath equals: Path workingDirectory \ 'Dolphin'.
	self assert: '.\Dolphin' asPath fullPath equals: Path workingDirectory \ 'Dolphin'.
	"With extended characters"
	self assert: 'a🐬.£b' asPath fullPath equals: Path workingDirectory \ 'a🐬.£b'.
	"An odd case where the first call to GetFullPath (to request the buffer size) returns space for two extra chars, presumably the '.\', but returns the correct size when actually invoked with a buffer."
	self assert: '.\Dolphin' asPath fullPath equals: Path workingDirectory \ 'Dolphin'.
	"Exactly MAX_PATH"
	longFilename := (String new: MAX_PATH - Path workingDirectory asString size - 1 withAll: $x) asPath.
	longPath := longFilename fullPath.
	self assert: longPath size equals: MAX_PATH - 1.
	self assert: longPath equals: Path workingDirectory \ longFilename.
	"MAX_PATH + 1"
	longFilename := (String new: MAX_PATH - Path workingDirectory size withAll: $y) asPath.
	longPath := longFilename fullPath.
	self assert: longPath size equals: MAX_PATH + self activeLongPathPrefix size.
	self assert: longPath asString equals: self activeLongPathPrefix, Path workingDirectory asString, longFilename asString.
	"MAX_PATH + 2"
	longFilename := (String new: MAX_PATH - Path workingDirectory size + 1 withAll: $y) asPath.
	longPath := longFilename fullPath.
	self assert: longPath size equals: MAX_PATH + 1 + self activeLongPathPrefix size.
	self assert: longPath asString equals: self activeLongPathPrefix, Path workingDirectory asString, longFilename asString.
	"Very long absolute path in long format"
	longPath := String writeStream.
	longPath nextPutAll: '\\?'.
	20 timesRepeat: [longPath nextPutAll: '\abcdefghijklmnopqrstuvwxyz'].
	longPath := longPath contents asPath.
	self assert: longPath size > MAX_PATH.
	self assert: longPath fullPath equals: longPath!

testHasDirectory
	#('' 'a' 'ab' 'a.b') do: [:each | self deny: each asPath hasDirectory].
	#('\' '\a' '\ab' '\a.b' 'a\' 'a\b' 'a.b\' '/' '/a' '/ab' '/a.b' 'a/' 'a/b' 'a.b/')
		do: [:each | self assert: each asPath hasDirectory]!

testHasDrive
	#('c:\' 'c:' 'c:\a\b.tst' '\\?\c:' '\\?\c:\' '\\?\c:\a\b.txt')
		do: [:each | self assert: each asPath hasDrive].
	#('' 'a' 'ab' 'abc' '\' '\a' '\a\b.txt' '.:' '\\?\' '\\?\c' '\\?\a\b' '\\a' '\\')
		do: [:each | self deny: each asPath hasDrive]!

testIsRelative
	#('c:\' '\\?\c:\' 'c:\.' 'c:\foo\..' '\\?\c:\foo\..' '\' 'c:/' 'c:\blah.txt' 'c:\foo\..\bar.txt')
		do: [:each | self deny: each asPath isRelative].
	#('.' '..' '.\' '..\' 'blah' 'blah.txt' 'foo\bar' 'foo\bar.txt' '.\foo' '.\foo\bar' '.\foo.txt' '.\foo\bar.txt' '..\foo' '..\foo\bar.txt' 'c:' '-' '-:\')
		do: [:each | self assert: each asPath isRelative].
	"Some boundary cases"
	self assert: ':' asPath isRelative.
	self assert: Path new isRelative.
	self assert: '' asPath isRelative.
	"PathIsRelative API also doesn't recognise long path prefix, but just treats as if a root path. This appears consistent with the OpenFile API."
	self deny: '\\?\foo.txt' asPath isRelative!

testIsRelativeForwardSlash
	self deny: '/' asPath isRelative.
	self deny: 'c:/' asPath isRelative.
	self deny: 'D:/' asPath isRelative.
	self assert: 'a/' asPath isRelative.
	self assert: './' asPath isRelative!

testIsRelativeOnDrive
	"There is a current directory for every drive, so paths that start with a drive can still be relative, See [Fully Qualified vs. Relative Paths](https://learn.microsoft.com/en-us/windows/win32/fileio/naming-a-file#fully-qualified-vs-relative-paths)"

	self assert: ('c:foo.txt' asPath isRelative).
	self assert: ('c:foo\bar' asPath isRelative)!

testIsRoot
	#('\' 'c:\' '\\?\c:\' '\\server\share' '\\server' '\\' '\\?\UNC\' '\\?\UNC\server\share' '\\?\UNC\server')
		do: [:each | self assert: each asPath isRoot].
	#('' 'c:' 'c:\foo' '\foo' 'c:\foo\..' '\\server\' '\\server\share\' '\\server\share\file' '\\?\UNC\server\share\' '\\?\c:' '\\?\c:\foo' '\\?\c:\foo\..' '/' 'c:\blah.txt' '.\blah.txt' 'con:\')
		do: [:each | self deny: each asPath isRoot].
	self deny: Path new isRoot.
	"Note that the Unix directory separator is not accepted (a Windows API is used)"
	self deny: 'c:/' asPath isRoot.
	"This is really a root path, but uncanonicalized"
	self deny: 'c:\.' asPath isRoot.
	"Ditto"
	self deny: 'c:\foo\..' asPath isRoot!

testIsUnc
	#('\\server\share' '\\server' '\\' '\\?\UNC\' '\\?\UNC\server\share' '\\?\UNC\server')
		do: [:each | self assert: each asPath isUnc].
	#('' 'c:' 'c:\foo' '\foo' 'c:\foo\..' '\\?\c:' '\\?\c:\foo' '\\?\c:\foo\..' '/' 'c:\blah.txt' '.\blah.txt' 'con:\')
		do: [:each | self deny: each asPath isUnc].
!

testMake
	| filename split |
	self assert: (Path make: #('c:' 'a/b 2/c/' 'a file' '.anextension'))
		equals: 'c:a/b 2/c/a file.anextension' asPath.
	self assert: (Path make: #('c' '\dir' 'file' 'txt')) equals: 'c:\dir\file.txt' asPath.
	self assert: (Path make: #(nil nil nil nil)) equals: '' asPath.
	self assert: (Path make: #('' '' '' '')) equals: '' asPath.
	self assert: (Path make: #('c' '' '' '')) equals: 'c:' asPath.
	self assert: (Path make: #('c' 'abc' '' '')) equals: 'c:abc\' asPath.
	self assert: (Path make: #('c' '' 'file' '')) equals: 'c:file' asPath.
	self assert: (Path make: #('c' '' '' 'txt')) equals: 'c:.txt' asPath.
	self assert: (Path make: #('c' '' 'a 🐬 c' 'txt')) equals: 'c:a 🐬 c.txt' asPath.
	self assert: (Path make: #('c' 'a/b' 'file' '')) equals: 'c:a/b\file' asPath.
	self assert: (Path make: #('c' '\' '' '')) equals: 'c:\' asPath.
	self assert: (Path make: #('' 'a\b' '' '')) equals: 'a\b\' asPath.
	self assert: (Path make: #('' '' 'file' '')) equals: 'file' asPath.
	self assert: (Path make: #('' '' '' 'txt')) equals: '.txt' asPath.
	"Shouldn't matter if the filename is notionally too long"
	filename := String writeStream.
	self printFilenameOfLength: self maxFname * 2 on: filename.
	filename := filename contents.
	split := filename subStrings: $..
	self assert: (Path make: { nil. nil. split first. split second }) equals: filename asPath!

testRelativeTo
	"N.B. To path is assumed to be a directory only if it has a trailing slash, *otherwise the last portion is ignored*"

	self assert: (self relativePathOf: '.' to: '.') equals: '.'.
	self assert: (self relativePathOf: '..' to: '.') equals: '..'.
	self assert: (self relativePathOf: '..\' to: '.') equals: '..\'.
	self assert: (self relativePathOf: '..' to: '.\') equals: '..'.
	self assert: (self relativePathOf: '.' to: '..') equals: '.'.
	self assert: (self relativePathOf: '.\' to: '..\') equals: ''.
	self assert: (self relativePathOf: '.\' to: '..') equals: ''.
	self assert: (self relativePathOf: '.' to: '..\') equals: '.'.
	self assert: (self relativePathOf: '.\' to: '..\') equals: ''.
	self assert: (self relativePathOf: 'c:\' to: 'd:\') equals: 'c:\'.
	self assert: (self relativePathOf: 'c:\1\a🐬b.txt' to: 'c:\') equals: '1\a🐬b.txt'.
	self assert: (self relativePathOf: 'c:\1\a🐬b.txt' to: 'c:\1\') equals: 'a🐬b.txt'.
	self assert: (self relativePathOf: 'c:\1\a🐬b.txt' to: 'c:\1') equals: '1\a🐬b.txt'.
	self assert: (self relativePathOf: 'c:\1\a🐬b.txt' to: 'c:\1.txt') equals: '1\a🐬b.txt'.
	self assert: (self relativePathOf: 'c:\1\a🐬b.txt' to: 'c:\2\') equals: '..\1\a🐬b.txt'.
	self assert: (self relativePathOf: 'c:\1\a🐬b.txt' to: 'c:\2') equals: '1\a🐬b.txt'.
	self assert: (self relativePathOf: 'c:\1\a🐬b.txt' to: 'c:\2.txt') equals: '1\a🐬b.txt'.
	self assert: (self relativePathOf: 'c:\1\11\a🐬b.txt' to: 'c:\1') equals: '1\11\a🐬b.txt'.
	self assert: (self relativePathOf: 'c:\1\11\a🐬b.txt' to: 'c:\1\') equals: '11\a🐬b.txt'.
	self assert: (self relativePathOf: 'c:\1\11\a🐬b.txt' to: 'c:\2\21\')
		equals: '..\..\1\11\a🐬b.txt'.
	self assert: (self relativePathOf: 'c:\1\11\a🐬b.txt' to: 'c:\2\21') equals: '..\1\11\a🐬b.txt'.
	self assert: (self relativePathOf: 'c:\1\11\a🐬b.txt' to: 'c:\2\21.txt')
		equals: '..\1\11\a🐬b.txt'.

	"Example from MS IMoniker documentation"
	self assert: (self relativePathOf: 'c:\projects\secret\art\pict1.bmp'
				to: 'c:\projects\secret\docs\chap1.txt')
		equals: '..\art\pict1.bmp'.
	self assert: (self relativePathOf: 'c:\projects\secret\docs\chap1.txt'
				to: 'c:\projects\secret\art\pict1.bmp')
		equals: '..\docs\chap1.txt'.
	"A common type of useage in Dolphin (image relative path)"
	self assert: (self
				relativePathOf: 'd:\object arts\dev\dolphin5\Packages\Dolphin\Database\Database Connection.pax.pac'
				to: 'd:\object arts\dev\dolphin5\')
		equals: 'Packages\Dolphin\Database\Database Connection.pax.pac'.
	"Non-canonical path with redundant components - note result is not canonical either"
	self
		assert: ('d:\dummy\..\object arts\dev\dummy\..\dolphin5\Packages\Dolphin\Database\Database Connection.pax' asPath fullPathRelativeTo: 'd:\object arts\dev\dolphin5\')
		equals: 'd:\object arts\dev\dolphin5\Packages\Dolphin\Database\Database Connection.pax' asPath.

	"Already a relative path (therefore fails and answers first argument)"
	self assert: (self relativePathOf: 'Packages\Dolphin\Database\Database Connection.pax'
				to: 'd:\object arts\dev\dolphin5\')
		equals: 'Packages\Dolphin\Database\Database Connection.pax'.
	self assert: (self relativePathOf: '.\Packages\Dolphin\Database\Database Connection.pax'
				to: 'd:\object arts\dev\dolphin5\')
		equals: 'Packages\Dolphin\Database\Database Connection.pax'.
	self assert: (self relativePathOf: '..\dolphin5\Packages\Dolphin\Database\Database Connection.pax'
				to: 'd:\object arts\dev\dolphin5\')
		equals: '..\dolphin5\Packages\Dolphin\Database\Database Connection.pax'!

testRemoveDirectory
	| testDir |
	self createTestDirectories.
	testDir := tempDir \ 'FileTest1'.
	self removeDirectory: testDir \ 'EmptyLeaf\'.
	self removeDirectory: testDir \ 'BranchWithEmptyLeaf\EmptyLeaf1\'.
	self removeDirectory: testDir \ 'BranchWithEmptyLeaves\EmptyLeaf1\'.
	self removeDirectory: testDir \ 'BranchWithEmptyLeaves\EmptyLeaf2\'.
	self removeDirectory: testDir \ 'BranchWithEmptyLeaves\'.
	"Presense of sub-directories or files should prevent remove working"
	self should: [(testDir \ 'FileTest1\LeafWithFile\') removeDirectory] raise: Win32Error.
	self should: [(testDir \ 'BranchWithEmptyLeaves\') removeDirectory] raise: Win32Error!

testSetReadOnly
	| maxComponentLength |
	tempDir := Path newTemporaryDirectory.
	self assert: tempDir isDirectory.
	maxComponentLength := (DiskVolumeInformation forPath: tempDir) maxComponentLength.
	{
		Character dolphin asString , (String new: maxComponentLength - 2 withAll: $£).
		String new: MAX_PATH - tempDir asUtf16String size - 2 withAll: $b.
		String new: MAX_PATH - tempDir asUtf16String size - 1 withAll: $c
	} do: 
				[:each |
				| temp |
				temp := tempDir \ each.
				(File write: temp)
					write: 'Hello world';
					close.
				self assert: temp isWriteable.
				temp isWriteable: false.
				self deny: temp isWriteable.
				temp isWriteable: true]!

testShortForm
	"This test will only work if short filenames are enabled for the volume on which temp files are stored, and we cannot guarantee this is the case on build machines, nor is there an API that provides a definite answer as to whether short filenames are enabled on a particular volume."

	<skipIf: #isCiBuild>
	| sysdir tmpDir tmpFile |
	sysdir := SessionManager current systemDirectory.
	self assert: sysdir asPath shortForm path asAnsiString equals: sysdir.
	tmpDir := (Path tempDirectory \ (GUID newUnique asString , Character dolphin asUtf8String))
				withSeparator.
	tmpFile := tmpDir \ '🖕.txt'.
	tmpFile createDirectory.
	
	[| short |
	(File open: tmpFile mode: #create) close.
	short := tmpFile shortForm.
	self deny: short path equals: tmpFile path.
	"This will fail if the short name still includes unicode"
	self assert: short exists.
	short := short path asAnsiString.
	self assert: (File exists: short)]
			ensure: [tmpDir delete]!

testStem
	| path |
	self assert: '.' asPath stem equals: ''.
	self assert: 'c:\a\a🐬/b.txt' asPath stem equals: 'b'.
	self assert: 'a\b.txt' asPath stem equals: 'b'.
	self assert: 'b.txt' asPath stem equals: 'b'.
	self assert: 'a🐬.txt' asPath stem equals: 'a🐬'.
	self assert: 'b.' asPath stem equals: 'b'.
	self assert: '.txt' asPath stem equals: ''.
	self assert: '' asPath stem equals: ''.
	self assert: '\' asPath stem equals: ''.
	self assert: 'c:\' asPath stem equals: ''.
	self assert: 'c:\.txt' asPath stem equals: ''.
	self assert: 'c:\a\b\' asPath stem equals: ''.
	self assert: 'c:/a b\c 🐬.txt' asPath stem equals: 'c 🐬'.
	self assert: '1234.1234.exe' asPath stem equals: '1234.1234'.
	self assert: 'a.b\c' asPath stem equals: 'c'.
	self assert: 'a.b\' asPath stem equals: ''.
	path := self buildTestPathOfLength: MAX_PATH.
	self assert: path asPath stem equals: ((path subStrings: $\) last upTo: $.).
	"Try a very long filename (> max length), this will still work."
	path := String writeStream.
	path nextPutAll: 'c:\'.
	self printFilenameOfLength: self maxFname * 2 on: path.
	path := path contents.
	self assert: path asPath stem equals: ((path copyFrom: 4) upTo: $.)!

testWithDefaultExtension
	| s s2 |
	#(#('' '' '') #('a.' '' 'a') #('a.' '.' 'a.') #('a' '' 'a') #('a' '.b' 'a.b') #('a.' 'b' 'a.b') #('a.' '.b' 'a.b') #('a.b' '.c' 'a.b') #('abc' 'txt' 'abc.txt') #('abc.def\xyz' '.txt' 'abc.def\xyz.txt') #('abc.d\xy' 'txt' 'abc.d\xy.txt') #('x\' '🐬' 'x\.🐬') #('文字化け\你🐬好' 'dll' '文字化け\你🐬好.dll') #('x\abc.a🐬' 'txt' 'x\abc.a🐬'))
		do: 
			[:each |
			| actual |
			actual := each first asPath withDefaultExtension: each second.
			self assert: actual equals: each last asPath.
			actual := each first asUtf16String asPath withDefaultExtension: each second asUtf16String.
			self assert: actual equals: each last asPath].
	"Long paths"
	s := String writeStream.
	s nextPutAll: 'c:'.
	10 timesRepeat: 
			[s
				nextPut: $\;
				nextPutAll: GUID newUnique idlString].
	s := s contents.
	self assert: s size > MAX_PATH.
	s2 := s asPath withDefaultExtension: 'txt'.
	self assert: s2 asString equals: self activeLongPathPrefix, s , '.txt'.
	s2 := s asPath withDefaultExtension: '.blah'.
	self assert: s2 asString equals: self activeLongPathPrefix, s , '.blah'!

testWithDelimiter
	#('' 'c:' 'c:\a' 'c:/a' 'c:\a\b' 'c:/a/b' 'c:\a\..' 'c:\a\.' 'c:..' 'c:\a🐬' 'c:\a£')
		do: [:each | self assert: each asPath withSeparator equals: (each , '\') asPath].
	#('\' '/' 'c:\' 'c:/' 'c:\a\' 'c:/a/' 'c:\a\b\' 'c:/a/b/' 'c:\a\..\' 'c:\a\.\' 'a\\'  'c:\a🐬\' 'c:\a£\') do: 
			[:each |
			| subject |
			subject := each asPath.
			self assert: subject withSeparator identicalTo: subject]!

testWithExtension
	| s s2 |
	#(#('' '' '') #('' 'a' '.a') #('' '.a' '.a') #('a' '' 'a') #('a.' '' 'a') #('a' 'b' 'a.b') #('a' '.b' 'a.b') #('a.b' 'c' 'a.c') #('a.exe' '.dll' 'a.dll') #('c:' 'bat' 'c:.bat') #('\' '.cmd' '\.cmd') #('ab\cd.exe' 'dll' 'ab\cd.dll') #('a\' 'b' 'a\.b') #('a.b' '' 'a') #('\a\b\.c' '' '\a\b\') #('a.longlonglonglongextension' '.evenlongerlonglonglonglongextension' 'a.evenlongerlonglonglonglongextension') #('c:\wibble\wobble' '.blah' 'c:\wibble\wobble.blah') #('文字化け.txt' '你🐬好' '文字化け.你🐬好') #('文字化け.你🐬好' '.txt' '文字化け.txt'))
		do: 
			[:each |
			| actual |
			actual := each first asPath withExtension: each second.
			self assert: actual equals: each last asPath].
	"Long paths"
	s := String writeStream.
	s nextPutAll: 'c:'.
	10 timesRepeat: 
			[s
				nextPut: $\;
				nextPutAll: GUID newUnique idlString].
	s := s contents.
	self assert: s size > MAX_PATH.
	s2 := s asPath withExtension: 'txt'.
	self assert: s2 asString equals: self activeLongPathPrefix, s , '.txt'.
	s2 := s asPath withExtension: '.blah'.
	self assert: s2 asString equals: self activeLongPathPrefix, s , '.blah'!

testWithLongPrefix
	self assert: ('c:\' \ 'foo.txt') withLongPrefix path equals: OS.KernelLibrary.LongPathPrefix , 'c:\foo.txt'.
	self assert: ((OS.KernelLibrary.LongPathPrefix , 'c:\') \ 'foo.txt') withLongPrefix path
		equals: OS.KernelLibrary.LongPathPrefix , 'c:\foo.txt'.
	self
		assert: ((OS.KernelLibrary.LongPathPrefix , 'c:\') \ (String new: MAX_PATH - 6 withAll: $a)) withLongPrefix path
		equals: OS.KernelLibrary.LongPathPrefix , 'c:\' , (String new: MAX_PATH - 6 withAll: $a)!

testWithoutDelimiter
	#('\' '/' 'c:\' 'c:/' 'c:\a\' 'c:/a/' 'c:\a\b\' 'c:/a/b/' 'c:\a\..\' 'c:\a\.\' 'c:\a🐬\' 'c:\a£\')
		do: [:each | self assert: each asPath withoutSeparator asString equals: each allButLast].
	#('' 'c:' 'c:\a' 'c:/a' 'c:\a\b' 'c:/a/b' 'c:\a\..' 'c:\a\.' 'c:\a🐬' 'c:\a£') do: 
			[:each |
			| subject |
			subject := each asPath.
			self assert: subject withoutSeparator identicalTo: subject]!

testWithoutExtension
	| path |
	self assert: 'a.' asPath withoutExtension equals: 'a' asPath.
	self assert: '.exe' asPath withoutExtension equals: '' asPath.
	self assert: '.' asPath withoutExtension equals: '' asPath.
	self assert: '1234.123🐬.exe' asPath withoutExtension equals: '1234.123🐬' asPath.
	self assert: '1234.1234.+' asPath withoutExtension equals: '1234.1234' asPath.
	self assert: 'c:/a/b.txt' asPath withoutExtension equals: 'c:/a/b' asPath.
	#('' 'a' 'c:\a' 'c:\a\b' 'a.b\c' 'a.b\' '\') do: 
			[:each |
			path := each asPath.
			self assert: path withoutExtension identicalTo: path].
	path := String writeStream.
	path nextPutAll: 'c:\'.
	self printFilenameOfLength: self maxFname on: path.
	path := path contents.
	self assert: path asPath withoutExtension equals: (self activeLongPathPrefix, ((path subStrings: $.)) first) asPath.
	"Doesn't matter if the path is notionally too long"
	path := self buildTestPathOfLength: MAX_PATH * 2.
	self assert: path asPath withoutExtension equals: (path subStrings: $.) first asPath! !

!Core.Tests.PathTest categoriesForMethods!
activeLongPathPrefix!helpers!private! !
buildTestPathOfLength:!helpers!private! !
createTestDirectories!helpers!private! !
deleteDirectory:!helpers!private! !
maxFname!constants!private! !
printFilenameOfLength:on:!helpers!private! !
relativePathOf:to:!helpers!private! !
removeDirectory:!helpers!private! !
tearDown!private!Running! !
testAppend!public!unit tests! !
testCanonicalized!public!unit tests! !
testCombinedWith!public!unit tests! !
testCommonPrefixWith!public!unit tests! !
testComparing!public!unit tests! !
testCreateDirectory!public!unit tests! !
testCreateDirectoryPath!public!unit tests! !
testCreateTemporaryDirectory!public!unit tests! !
testDeleteDirectory!public!unit tests!unit tests-legacy API! !
testDeleteDirectory2!public!unit tests!unit tests-legacy API! !
testDirectory!public!unit tests! !
testDirectoryName!public!unit tests! !
testDrive!public!unit tests! !
testExtension!public!unit tests! !
testFileName!public!unit tests! !
testFileTimes!public!unit tests! !
testFindFiles!public!unit tests! !
testFindMatching!public!unit tests! !
testForDirectories!public!unit tests! !
testFullPath!public!unit tests! !
testHasDirectory!public!unit tests! !
testHasDrive!public!unit tests! !
testIsRelative!public!unit tests! !
testIsRelativeForwardSlash!public!unit tests! !
testIsRelativeOnDrive!public!unit tests! !
testIsRoot!public!unit tests! !
testIsUnc!public!unit tests! !
testMake!public!unit tests-legacy API! !
testRelativeTo!public!unit tests! !
testRemoveDirectory!public!unit tests-legacy API! !
testSetReadOnly!public!unit tests! !
testShortForm!public!unit tests! !
testStem!public!unit tests! !
testWithDefaultExtension!public!unit tests-legacy API! !
testWithDelimiter!public!unit tests! !
testWithExtension!public!unit tests-legacy API! !
testWithLongPrefix!public!unit tests! !
testWithoutDelimiter!public!unit tests! !
testWithoutExtension!public!unit tests! !
!

