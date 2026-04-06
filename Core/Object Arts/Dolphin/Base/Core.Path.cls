"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.Path'
	instanceVariableNames: 'path'
	classVariableNames: 'SeparatorString'
	imports: #(#{OS.PathCchLibrary private} #{OS.KernelLibrary private} #{OS.Win32Error private} #{OS private})
	classInstanceVariableNames: ''
	classConstants: {
			'DriveSeparator' -> $:.
			'ExtensionSeparator' -> $..
			'Separator' -> $\.
			'Separators' -> '/\'.
			'UnixSeparator' -> $/
		}!

Core.Path guid: (Core.GUID fromString: '{38ace293-bc16-491a-820b-d9059a7e6dfe}')!

Core.Path comment: '

# Terminology:

* directory - path to a filesystem directory
* path - some combination of drive, directory, file stem and extension. Refers to a directory or file.
* file name (filename) - the name of a file in the context of its directory (i.e. file stem and extension components)
* extension - the last component of a file path appearing after the file stem, separated by a dot/period.
* fully qualified path - an absolute path including all components that can be resolved to a filesystem object.
* relative path	- a partial path that can be resolved to a filesystem object only in context. Can include directory and/or filename, but never a drive or volume
* separator - separator between components of a path (except stem and extension), and between individual directories in a directory path
* stem - file name without extension
* volume - physical filesystem volume
* drive - The drive letter component of a path, e.g. c:. This is a logical mapping to a partition of a volume.
* UNC path - a fully qualified path beginning with \\<hostname>'!

!Core.Path methodsFor!

\ aPathOrString
	"Append the <Path> or <String> argument to the receiver to construct a combination <Path>. Note that any .\ or ..\ components are retained, but see also #combinedWith:"

	^self append: aPathOrString!

<= aPath
	"Answer whether the receiver is less than or equal to the <Path> argument."

	^self <=> aPath <= 0!

<=> aPath
	"Answer the receiver's <integer> collation order with respect to the <Path> argument, based on case-insensitive ordinal comparison of the receiver's string path."

	"For file paths on Windows it is correct to use an ordinal case-insensitive collation."
	^path compareOrdinals: aPath asString ignoringCase: true!

= anObject
	"Answer whether the receiver and argument are equivalent."

	self == anObject ifTrue: [^true].
	self species == anObject species ifFalse: [^false].
	^self <=> anObject == 0!

append: aPathOrString
	"Append the <Path> or <String> argument to the receiver to construct a combination <Path>. Note that any .\ or ..\ components are retained if possible. If the process is not long path aware, e.g. because the underlying OS is not configured for long paths, and the path lengths exceeds the maximum short path, then the long path prefix, \\?\, must be prepended. Since paths with the long path prefix cannot contain relative components, any '.' or '..' components must be removed in this case. The net result is that in this corner case, the result is the same as #combinedWith:"

	| subPath count last |
	aPathOrString isEmpty ifTrue: [^self].
	count := path size.
	subPath := aPathOrString asPath.
	(count == 0 or: [subPath isRoot or: [subPath hasDrive]]) ifTrue: [^subPath].
	last := path at: count.
	^self class
		fromString: ((last == Separator or: [last == UnixSeparator])
				ifTrue: [path]
				ifFalse: [path copyWith: Separator]) , aPathOrString asUtf16String!

asPath
	^self!

asString
	"Answer the receiver's path <String>."

	^path!

asUtf16String
	"Answer the receiver's path as a <Utf16String>."

	^path asUtf16String!

asUtf8String
	"Answer the receiver's path as a <Utf8String>."

	^path asUtf8String!

attributes
	"Answer the Win32 file attributes flags of the file identified by the receiver."

	^Kernel32 getFileAttributes: path!

basicCreateDirectoryPath
	| pos result len |
	result := self attributes.
	result == -1
		ifFalse: 
			[(result allMask: FILE_ATTRIBUTE_DIRECTORY)
				ifFalse: 
					["The target exists as a file"
					Win32Error signalWith: ERROR_FILE_EXISTS].
			"Target directory exists"
			^false].
	result := false.
	(path beginsWith: '\\')
		ifTrue: 
			[pos := 3.
			2 timesRepeat: 
					["Skip UNC machine name and share, or long path prefix"
					pos := path indexOfAnyOf: Separators startingAt: pos.
					pos == 0 ifTrue: [^Win32Error signalWith: ERROR_INVALID_NAME].
					pos := pos + 1]]
		ifFalse: [pos := 1].
	len := path size.
	[pos <= len] whileTrue: 
			[| end |
			end := path indexOfAnyOf: Separators startingAt: pos.
			end == 0 ifTrue: [end := len + 1].
			(end == 1 or: 
					["Don't attempt to create the drive!!"
					(path at: end - 1) == $:])
				ifFalse: [result := Kernel32 createDirectory: (path copyFrom: 1 to: end - 1)].
			pos := end + 1].
	^result!

basicDeleteDirectory
	"Private - Recursively delete all files and folders within the directory targeted by the receiver, and remove the directory itself."

	self for: '*.*'
		do: 
			[:each |
			each isDirectory
				ifTrue: 
					[| filename |
					filename := each fileName.
					(filename = '.' or: [filename = '..']) ifFalse: [each fullPath basicDeleteDirectory]]
				ifFalse: [each fullPath basicDeleteFile]].
	^self basicRemoveDirectory!

basicDeleteFile
	^(Kernel32 deleteFile: path) ifFalse: [Kernel32 systemError]!

basicRemoveDirectory
	(Kernel32 removeDirectory: path) ifFalse: [Kernel32 systemError]!

canonicalized
	"Answer a new <Path> representing the canonical form of the receiver, i.e. removing any embedded '..' and '.' components, and adding a long path prefix if required."

	| canon |
	canon := PathCch pathCanonicalize: path dwFlags: PATHCCH_ALLOW_LONG_PATHS.
	^canon = path ifTrue: [self] ifFalse: [self class fromString: canon]!

combinedWith: aPathOrString
	"Answer a new <Path> combining the receiver as a base path and the <Path> or <String> argument as a sub-path. Note that any .\ or ..\ components are removed."

	^self class fromString: (PathCch
				pathCombine: path
				pszMore: aPathOrString
				dwFlags: PATHCCH_ALLOW_LONG_PATHS)!

commonPrefixWith: aPathOrString
	"Answer a new <Path> representing the common prefix shared between the receiver and the argument. The result will be empty if the receiver shares no common prefix with the argument."

	| prefix len path1 path2 |
	path1 := path asUtf16String.
	path2 := aPathOrString asUtf16String.
	len := Shlwapi
				pathCommonPrefix: path1
				pszFile2: path2
				achPath: nil.
	len == 0 ifTrue: [^self class fromString: ''].
	prefix := Utf16String newFixed: len.
	Shlwapi
		pathCommonPrefix: path1
		pszFile2: path2
		achPath: prefix.
	^self class fromString: prefix!

copyTo: aPathOrString
	"Copy the file specified by oldFileNameString to newFileNameString.
	Signal a HostSystemError if the copy fails."

	Kernel32 copyFile: path asUtf16String to: aPathOrString asUtf16String!

createDirectory
	"Create the directory targeted by the receiver. Answer whether the directory was actually created, or already existed.
	Raise a Win32Error if the call fails for any other reason than that the directory already exists."

	^Kernel32 createDirectory: self directoryName!

createDirectoryPath
	"Create a directory tree with the receiver's path - i.e. this will create a nested set of directories to any depth. Answer true if the final directory was actually created, or false if it already existed. 
	Raise a Win32Error if the call fails for any other reason than that a directory with the specified path already exists."

	"Implementation Note: This may attempt more directory creation operations than are necessary, (e.g. to create the root directory if a drive is specified) but such requests are ignored."

	^self directory withoutSeparator basicCreateDirectoryPath!

delete
	"Delete the file or (recursively) directory referenced by the receiver. Signal a Win32Error if the operation fails.
	This can be an impactful operation as it can recursively delete an entire directory tree, so should be used with care!!"

	| attribs |
	attribs := self attributes.
	attribs ~= -1 ifFalse: [^false].
	^(attribs allMask: FILE_ATTRIBUTE_DIRECTORY)
		ifTrue: [self basicDeleteDirectory]
		ifFalse: [self basicDeleteFile]!

deleteDirectory
	"Recursively delete all files and folders within the directory referenced by the receiver, and remove the directory itself.
	This can be an impactful operation, and should be used with care!!"

	^self directory basicDeleteDirectory!

deleteFile
	"Delete the file referenced by the receiver. Signal an error if the target is a directory rather than a file, or if the OS refuses. It is not an error to attempt to delete a non-existant file. Answer whether the file existed before deletion."

	| attribs |
	attribs := self attributes.
	attribs == -1 ifTrue: [^false].
	(attribs allMask: FILE_ATTRIBUTE_DIRECTORY)
		ifTrue: [self error: path , ' is a directory, not a file'].
	^self basicDeleteFile!

directory
	"Answer a <Path> to the the directory referred to by the receiver. Will include a drive letter if the receiver is a fully-qualified path (i.e. a combination of drive and directory components). May be empty if the receiver specifies only a filename."

	| dir |
	dir := self directoryName.
	^dir = path ifTrue: [self] ifFalse: [self class fromString: dir]!

directoryName
	"Answer the directory referred to by the path. Will include a drive letter if the receiver is a fully-qualified path (i.e. a combination of drive and directory components). May be empty if the receiver specifies only a filename."

	| i |
	i := path size.
	
	[i == 0 or: 
			[| ch |
			ch := path at: i.
			ch == Separator or: [ch == UnixSeparator or: [ch == DriveSeparator]]]]
			whileFalse: [i := i - 1].
	^path copyFrom: 1 to: i!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	path displayOn: aPuttableStream!

drive
	"Answers the drive portion of the receiver's path, or an empty string if there is no drive component in the path."

	| i |
	i := self findDriveLetter.
	i == 0 ifTrue: [^''].
	^path copyFrom: i to: i + 1!

exists
	"Answer true if there is a file at the receiver's path."

	^self attributes ~~ -1!

extendedAttributes
	"Answer the <WIN32_FILE_ATTRIBUTE_DATA> for the file with the receiver's path, or nil if no such file exists."

	| attributes |
	attributes := WIN32_FILE_ATTRIBUTE_DATA newBuffer.
	^(Kernel32
		getFileAttributesEx: path
		fInfoLevelId: 0
		lpFileInformation: attributes) ifTrue: [attributes]!

extension
	"Answer the extension portion of the receiver's filename, or the empty string if there is no extension."

	| dotIndex |
	dotIndex := self findExtension.
	dotIndex == 0 ifTrue: [^''].
	^path copyFrom: dotIndex + 1 to: path size!

fileName
	"Splits the file name portion (including extension) or the receiver's path, or empty string if there is no filename component in the path."

	| i size |
	i := size := path size.
	
	[i == 0 or: 
			[| ch |
			ch := path at: i.
			ch == Separator or: [ch == UnixSeparator or: [ch == DriveSeparator]]]]
			whileFalse: [i := i - 1].
	^path copyFrom: i + 1 to: size!

fileSize
	"Answer the <integer> size of the file."

	^self extendedAttributes ifNotNil: [:attributes | attributes fileSize]!

findDriveLetter
	| count |
	count := path size.
	count > 1
		ifTrue: 
			[((path at: 2) == $: and: [(path at: 1) isEnglishLetter]) ifTrue: [^1].
			(count > 5
				and: [(path beginsWith: '\\?\') and: [(path at: 6) == $: and: [(path at: 5) isEnglishLetter]]])
					ifTrue: [^5]].
	^0!

findExtension
	"Private - Answer the start of the extension portion of the receiver's filename (the index of the dot), or 0 if there is no extension."

	| i |
	i := path size.
	
	[i == 0 or: 
			[| ch |
			ch := path at: i.
			ch == ExtensionSeparator
				ifTrue: 
					["We've found the start of the extension"
					^i].
			"If we find another path separator while searching backward, then there is no extension"
			ch == Separator or: [ch == UnixSeparator or: [ch == DriveSeparator]]]]
			whileFalse: [i := i - 1].
	^0!

findMatching
	| answer |
	answer := OrderedCollection new.
	self directory for: self fileName do: [:match | answer add: match fullPath].
	^answer
"
('c:\windows' \ '*.*') findMatching
"!

for: matchString do: aMonadicValuable
	"For each file/directory matching the wildcarded string argument, matchString, in the receiver's directory, evaluate the monadic valuable, aMonadicValuable, passing it <WIN32_FIND_DATA>s describing each matching file or sub-directory."

	| hFind findStruct pattern |
	findStruct := WIN32_FIND_DATAW newBuffer.
	findStruct directory: self.
	pattern := (self \ matchString) asUtf16String.
	hFind := Kernel32 findFirstFile: pattern lpFindFileData: findStruct.
	hFind isInvalid
		ifTrue: 
			[| err |
			err := Kernel32 getLastError.
			^(err == ERROR_FILE_NOT_FOUND or: [err == ERROR_ACCESS_DENIED])
				ifFalse: [Kernel32 systemError: err]].
	
	[| error |
	
	[aMonadicValuable value: findStruct.
	Kernel32 findNextFile: hFind lpFindFileData: findStruct] whileTrue.
	error := Kernel32 getLastError.
	error == ERROR_NO_MORE_FILES ifFalse: [^Kernel32 systemError: error]]
			ensure: [Kernel32 findClose: hFind]!

forAll: matchString do: operation
	"For each file or directory matching the wildcarded path string, matchString, in and below the directory identified by the receiver, evaluate the <monadicValuable>, operation, with <WIN32_FIND_DATA>s describing each matching file or sub-directory.  The special directories '.' and '..', are included in the enumeration if they match the pattern."

	self 
		for: matchString
		do: [:each | operation value: each].
	self forDirectoriesDo: 
			[:each | 
			each
				forAll: matchString
				do: operation]!

forAllDirectories: matchString do: operation
	"For each directory matching the wildcarded path string, matchString, in and below the directory identified by the receiver, evaluate the <monadicValuable>, aMonadicValuable, with a WIN32_FIND_DATA describing that directory as its argument. The special directories '.' and '..' are not included in the enumeration, even if they match the pattern."

	self forDirectories: matchString
		do: 
			[:each |
			operation value: each.
			self forAllDirectories: matchString do: operation]!

forDirectories: pattern do: aMonadicValuable
	"For each sub-directory of the the receiver that matches the the <Path> or <readableString> argument, pattern, evaluate the monadic valuable 2nd passing it <WIN32_FIND_DATA>s to describe each matching sub-directory. The special directories represent the current directory, '.', and parent directory, '..', are not included in the enumeration, even if they match the pattern."

	self for: pattern
		do: 
			[:each |
			(each isDirectory and: 
					[| fileName |
					fileName := each fileName.
					fileName ~= '.' and: [fileName ~= '..']])
				ifTrue: [aMonadicValuable value: each]]!

forDirectoriesDo: aMonadicValuable
	"For each sub-directory of the receiving Paths directory, evaluate the monadic valuable argument, passing it <WIN32_FIND_DATA>s describing each sub-directory.  The special directories represent the current directory, '.', and parent directory, '..', are not included in the enumeration."

	^self 
		forDirectories: '*.*'
		do: aMonadicValuable!

fullPath
	"Answers a <Path> representing the fully qualified path mapping to the receiver."

	| full |
	full := Kernel32 getFullPathName: path.
	^full = path ifTrue: [self] ifFalse: [self class fromString: full]!

fullPathRelativeTo: aBasePathOrString
	"Answers the full path of aPathnameString. If this is a truly relative path then it is formed as relative to aBasePath"

	^(self isRelative ifTrue: [aBasePathOrString \ self] ifFalse: [self]) fullPath!

hasDirectory
	"Answer whether the receiver includes a directory component (potentially just a drive)."

	| i |
	i := path size.
	
	[i == 0 or: 
			[| ch |
			ch := path at: i.
			ch == Separator or: [ch == UnixSeparator or: [ch == DriveSeparator]]]]
			whileFalse: [i := i - 1].
	^i > 0!

hasDrive
	"Answers whether the receiver specifies a drive."

	^self findDriveLetter ~~ 0!

hash
	"Answer the <integer> hash value for the receiver."

	^path hashOrdinalsIgnoringCase!

hasLongPrefix
	"Answer whether the receiver has the long path prefix, \\?\."

	^path beginsWith: LongPathPrefix!

isDirectory
	"Answer whether the receiver refers to a directory."

	| attribs |
	attribs := self attributes.
	^attribs ~~ -1 and: [attribs allMask: FILE_ATTRIBUTE_DIRECTORY]!

isEmpty
	^path isEmpty!

isLong
	"Answer whether the receiver is a long filename, i.e. one with a \\?\ prefix"

	^path beginsWith: '\\?\'!

isRelative
	"Answers whether the receiver is a relative path with no absolute components. See [Fully Qualified vs. Relative Paths](https://learn.microsoft.com/en-us/windows/win32/fileio/naming-a-file#fully-qualified-vs-relative-paths)."

	"The Microsoft documentation does not seem to specify the expected treatment of paths with the long path prefix, '\\?\', but empirically it seems these are always considered absolute. This would be consistent with treatment of UNC paths."

	| size first |
	size := path size.
	size == 0 ifTrue: [^true].
	first := path at: 1.
	(first == Separator or: [first == UnixSeparator]) ifTrue: [^false].
	(size <= 2 or: [first isEnglishLetter not]) ifTrue: [^true].
	^(path at: 2) ~~ DriveSeparator or: 
			[first := path at: 3.
			first ~~ Separator and: [first ~~ UnixSeparator]]!

isRoot
	"Answer whether the receiver is a UNC path, e.g. '\\server\share\a.txt'"

	^PathCch pathCchIsRoot: path!

isUnc
	"Answer whether the receiver is a UNC path, e.g. '\\server\share\a.txt'"

	^PathCch pathIsUNCEx: path ppszServer: nil!

isWriteable
	"Answer whether the file at the receiver's path is writeable. If there is no such file, then	the answer will be true. If there file exists then the answer is based on file's attributes - i.e. whether or not it has the read-only flag set. Note that file permissions are not taken into account, so even if the answer is true a subsequent attempt to open the file for writing may still fail."

	| attributes |
	attributes := self attributes.
	^(attributes ~= -1 and: [attributes allMask: FILE_ATTRIBUTE_READONLY]) not!

isWriteable: aBoolean
	"Set the writeable state of the file referenced by the receiver. Note that this only changes the file attribute."

	| attributes |
	attributes := self attributes.
	attributes == -1 ifTrue: [Kernel32 systemError].
	(Kernel32 setFileAttributes: path
		value: (attributes mask: FILE_ATTRIBUTE_READONLY set: aBoolean not))
			ifFalse: [Kernel32 systemError]!

lastAccessTime
	"Answer a <FILETIME> identifying the point in time at which the file associated with the receiver was last accessed."

	^self extendedAttributes ifNotNil: [:attributes | attributes ftLastAccessTime]!

lastWriteTime
	"Answer a <FILETIME> identifying the point in time at which some data was last written to the file associated with the receiver."

	^self extendedAttributes ifNotNil: [:attributes | attributes ftLastWriteTime]!

locateIn: anOrderedCollection
	"Answers the <Path> of the file referenced by the receiver where found in the specified search path. If the receiver includes a directory component already, then it is answered. Otherwise provided list of directories is search. If the file is not found in any of these directories then the receiver is answered."

	self hasDirectory
		ifFalse: 
			[anOrderedCollection do: 
					[:each |
					| fullpath |
					fullpath := each \ self.
					fullpath exists ifTrue: [^fullpath]]].
	^self!

notEmpty
	^path notEmpty!

path
	^path!

path: anObject
	path := anObject!

printOn: aPuttableStream
	"Answers the file stem component of the receiver's path, or an empty string if there is none."

	aPuttableStream
		nextPut: $(;
		print: self class;
		space;
		display: #fromString:;
		space;
		print: path;
		nextPut: $)!

relativeTo: aPathOrString
	"Answers a <Path> representing the relative path from the <Path> or <String> argument to the filesystem object referenced by the receiver.
	Note that if the last component of aPathOrString is to be considered a directory then there must be a trailing separator, otherwise the last component is ignored (it is treated as if it were a file name, not a directory)."

	| relPath toPath fromPath |
	#todo.	"Relative paths cannot be long, but the from/to paths theoretically could be. The API itself does not support long filenames, so will have to be replaced."
	relPath := Utf16String newFixed: MAX_PATH.
	toPath := path asUtf16String.
	fromPath := aPathOrString asUtf16String.
	relPath := (Shlwapi
				pathRelativePathTo: relPath
				pszFrom: fromPath
				dwAttrFrom: 0
				pszTo: toPath
				dwAttrTo: 0) ifTrue: [relPath] ifFalse: [toPath].
	^self class fromString: ((relPath beginsWith: '.\')
				ifTrue: [relPath copyFrom: 3 to: relPath strlen]
				ifFalse: [relPath trimNulls])!

removeDirectory
	self directory basicRemoveDirectory!

renameTo: aPathOrString
	"Rename the file referenced by the receiver to to newFileNameString.
	Signal a HostSystemError if the operation fails."

	(Kernel32 moveFile: path asUtf16String lpNewFileName: aPathOrString asUtf16String)
		ifFalse: [Kernel32 systemError]!

setPath: aUtf16String
	path := aUtf16String.
	^self!

setWorkingDirectory
	^Kernel32 setCurrentDirectory: path!

shortForm
	"Answer a new <Path> representing the abbreviated, aka 'short', form of the receiver."

	| short |
	short := Kernel32 getShortPathName: path.
	^short = path ifTrue: [self] ifFalse: [self class fromString: short]!

size
	"Answers the length of the path."

	^path size!

split
	"Answer the receiver's drive, directory, stem and extension components as an <Array> of 4 <String>s.
	Note: We use the C-runtime library to implement this, hence either backward or forward slashes (i.e. $\ or $/) are acceptable as pathname delimiters."

	| max drive dir fname ext utf8 |
	"To avoid problems with long filenames, we use the length of the input string as the buffer sizes - clearly the component parts can never be larger than this.  In order to support Unicode paths, we work in UTF-8."
	utf8 := path asUtf8String.
	max := utf8 size.
	max = 0 ifTrue: [^{ ''. ''. ''. '' }].
	Ucrt
		_splitpath_s: utf8
		drive: (drive := Utf8String new: CRTLibrary._MAX_DRIVE)
		driveLen: ##(CRTLibrary._MAX_DRIVE + 1)
		dir: (dir := Utf8String new: max)
		dirLen: max + 1
		fname: (fname := Utf8String new: max)
		fnameLen: max + 1
		ext: (ext := Utf8String new: max)
		extLen: max + 1.
	"CRT function includes leading period on extension, which we don't"
	^{
		drive trimNulls.
		dir trimNulls.
		fname trimNulls.
		ext copyFrom: (ext first == ExtensionSeparator ifTrue: [2] ifFalse: [1]) to: ext strlen
	}!

stem
	"Answers the file stem component of the receiver's path, or an empty string if there is none."

	| i size |
	i := size := path size.
	
	[i == 0 or: 
			[| ch |
			ch := path at: i.
			ch == ExtensionSeparator
				ifTrue: 
					[| end |
					"There is a file extension - stem must precede that"
					end := i := i - 1.
					
					[i == 0 or: 
							[ch := path at: i.
							ch == Separator or: [ch == UnixSeparator or: [ch == DriveSeparator]]]]
							whileFalse: [i := i - 1].
					^path copyFrom: i + 1 to: end].
			ch == Separator or: [ch == UnixSeparator or: [ch == DriveSeparator]]]]
			whileFalse: [i := i - 1].
	"No extension"
	^path copyFrom: i + 1 to: size!

withDefaultExtension: aString
	"Answer new <Path> that is either the receiver if it already has an extension, or a copy of the receiver but with the specified file extension."

	| dotIndex |
	dotIndex := self findExtension.
	^dotIndex == 0
		ifTrue: [self class stem: path extension: aString]
		ifFalse: 
			["Already has an extension, but replace it if empty"
			dotIndex == path size
				ifTrue: [self class stem: (path copyFrom: 1 to: dotIndex - 1) extension: aString]
				ifFalse: [self]]!

withDirectory: aPathOrString
	"Answer new <Path> that represents the receiver's filename in the specified directory."

	| oldPathComponents |
	oldPathComponents := self split.
	oldPathComponents
		at: 1 put: nil;
		at: 2 put: aPathOrString.	"new path can include drive letter"
	^self class make: oldPathComponents!

withExtension: aString
	"Answer new <Path> that is a copy of the receiver but with the specified file extension."

	| dotIndex |
	dotIndex := self findExtension.
	^dotIndex == 0
		ifTrue: 
			["No existing extension"
			aString size == 0 ifTrue: [self] ifFalse: [self class stem: self extension: aString]]
		ifFalse: 
			["We've found the start of an existing extension"
			self class fromString: (aString size == 0
						ifTrue: 
							["New extension is empty, so just remove the existing one"
							path copyFrom: 1 to: dotIndex - 1]
						ifFalse: 
							[(path copyFrom: 1
								to: ((aString at: 1) == ExtensionSeparator ifTrue: [dotIndex - 1] ifFalse: [dotIndex])) , aString])]!

withLongPrefix
	| canon |
	self hasLongPrefix ifTrue: [^self].
	canon := self canonicalized.
	canon hasLongPrefix ifTrue: [^canon].
	^self class basicFromString: LongPathPrefix , canon path!

withoutExtension
	"Answer a <Path> which is equivalent to the receiver but without an extension component."

	| dotIndex |
	dotIndex := self findExtension.
	^dotIndex == 0 ifTrue: [self] ifFalse: [self class fromString: (path copyFrom: 1 to: dotIndex - 1)]!

withoutSeparator
	"Answer a <Path> that is equivalent to the receiver but without any trailing separator."

	| count |
	count := path size.
	"In this case we know that the path delimiters only ever require one code unit in any encoding (they are both ascii characters), so it is safe to work with code units"
	^(count ~~ 0 and: 
			[| ch |
			ch := path at: count.
			ch == Separator or: [ch == UnixSeparator]])
		ifTrue: [self class fromString: (path copyFrom: 1 to: count - 1)]
		ifFalse: [self]!

withSeparator
	"Answer a <Path> that is equivalent to the receiver but with a trailing separator, therefore representing the accepted syntax for a directory reference.. If the receiver already has such a separator, then it is answered as is. Otherwise a new <Path> will result. 

		'c:\a\b' asPath directoryName	 = 'c:\a\'
		'c:\a\b' asPath withDelimiter directoryName = 'c:\a\b\'
	"

	| count |
	count := path size.
	(count ~~ 0 and: 
			[| last |
			last := path at: count.
			last == Separator or: [last == UnixSeparator]])
		ifTrue: [^self].
	^self class fromString: path , SeparatorString! !

!Core.Path categoriesForMethods!
\!filename manipulation!public! !
<=!comparing!public! !
<=>!comparing!public! !
=!comparing!public! !
append:!filename manipulation!public! !
asPath!converting!public! !
asString!converting!public! !
asUtf16String!converting!public! !
asUtf8String!converting!public! !
attributes!file information!public! !
basicCreateDirectoryPath!file operations!private! !
basicDeleteDirectory!file operations!private! !
basicDeleteFile!file operations!public! !
basicRemoveDirectory!file operations!private! !
canonicalized!filename manipulation!public! !
combinedWith:!filename manipulation!public! !
commonPrefixWith:!filename manipulation!public! !
copyTo:!file operations!public! !
createDirectory!file operations!public! !
createDirectoryPath!file operations!public! !
delete!file operations!public! !
deleteDirectory!file operations!public! !
deleteFile!file operations!public! !
directory!filename manipulation!public! !
directoryName!accessing!public! !
displayOn:!displaying!public! !
drive!accessing!public! !
exists!public!testing! !
extendedAttributes!file information!public! !
extension!accessing!public! !
fileName!accessing!public! !
fileSize!file information!public! !
findDriveLetter!helpers!private! !
findExtension!accessing!private! !
findMatching!enumerating!public! !
for:do:!enumerating!public! !
forAll:do:!enumerating!public! !
forAllDirectories:do:!enumerating!public! !
forDirectories:do:!enumerating!public! !
forDirectoriesDo:!enumerating!public! !
fullPath!filename manipulation!public! !
fullPathRelativeTo:!filename manipulation!public! !
hasDirectory!public!testing! !
hasDrive!public!testing! !
hash!comparing!public! !
hasLongPrefix!public!testing! !
isDirectory!public!testing! !
isEmpty!public!testing! !
isLong!public!testing! !
isRelative!public!testing! !
isRoot!public!testing! !
isUnc!public!testing! !
isWriteable!public!testing! !
isWriteable:!file operations!public! !
lastAccessTime!file information!public! !
lastWriteTime!file information!public! !
locateIn:!filename manipulation!public! !
notEmpty!public!testing! !
path!accessing!public! !
path:!accessing!private! !
printOn:!printing!public! !
relativeTo:!filename manipulation!public! !
removeDirectory!file operations!public! !
renameTo:!file operations!public! !
setPath:!initializing!private! !
setWorkingDirectory!file operations!public! !
shortForm!filename manipulation!public! !
size!accessing!public! !
split!filename manipulation!public! !
stem!accessing!public! !
withDefaultExtension:!filename manipulation!public! !
withDirectory:!filename manipulation!public! !
withExtension:!filename manipulation!public! !
withLongPrefix!public! !
withoutExtension!filename manipulation!public! !
withoutSeparator!filename manipulation!public! !
withSeparator!filename manipulation!public! !
!

!Core.Path class methodsFor!

appendPathDelimiter: aPathOrString
	"Answer a <readableString> that is the argument with a path separator appended to create the correct syntax for a path. If aPathOrString already ends in a path separator then the answer is equivalent."

	^aPathOrString asPath withSeparator asString!

attributes: aPathOrString
	"Answer the Win32 file attributes flags for the file identified by the <Path> or <String> argument."

	^aPathOrString asPath attributes!

basicFromString: aUtf16String
	<primitive: 157>
	^self new setPath: aUtf16String!

canonicalizePath: aPathOrString
	"Converts the <Path> or <String> argument into a canonical form, removing any embedded '..' and '.' components, and adding a long path prefix if required."

	^aPathOrString asPath canonicalized asString!

commonPrefixOf: aPathOrString1 and: aPathOrString2
	"Answer a <Path> representing the common prefix shared between the two <Path> or <String> arguments.
	This will be empty if the paths share no common prefix."

	^(aPathOrString1 asPath commonPrefixWith: aPathOrString2) asString!

compose: pathString stem: filestemString extension: extensionString
	"Composes a full pathname from the directory specified by the 1st <String> argument (which can include a drive), the file name stem specified by the 2nd <String> argument, and the file extension specified by the 3rd <String> argument. The path or extension components can be nil to construct a partial path."

	^self make: { nil. pathString. filestemString. extensionString }!

composePath: aPathOrString stem: aStemString extension: anExtensionString
	"Composes a full pathname from its components. The path or extension components 
	can be nil if necessary. The path can include the drive letter."

	^(self
		compose: aPathOrString
		stem: aStemString
		extension: anExtensionString) asString!

composePath: basePath subPath: subPath
	"Composes a full pathname from path and subpath components."

	^(basePath asPath combinedWith: subPath) asString!

composeShortStem: filestemString extension: extensionString
	"Answer a String which is a file name abbreviated from aStemString and anExtensionString.
	Lower case vowels are dropped from the right of aStemString until it is less than
	or equal to 8 characters.
	If still longer than 8 chars, then other lowercase letters are dropped from the
	right of the stem until it is less than or equal to 8 characters."

	^(self shortStem: filestemString extension: extensionString) asString!

composeStem: filestemString extension: extensionString
	"Composes a full pathname <String> from file stem and extension component <String>s. Note that the dot separator may be specified in the extension, or not."

	"Implementation Note: This could be implemented in terms of #composePath:stem:extension:, which ultimately is implemented in terms of #makePath:, however it is a very frequently used method so an optimized version which takes advantage of private knowledge of how file names are constructed is warranted."

	^(extensionString at: 1) == ExtensionSeparator
		ifTrue: [filestemString , extensionString]
		ifFalse: [filestemString , '.' , extensionString]!

createDirectoryPath: aPathOrString
	"Create a directory tree with the specified path - i.e. this will create a nested set of directories to any depth. Answer true if the final directory was actually created, or false if it already existed. 
	Raise a Win32Error if the call fails for any other reason than that a directory with the specified path already exists."

	^aPathOrString asPath withSeparator createDirectoryPath!

createTemporaryDirectory
	"Create a new, unique, temporary directory, and answer it's <readableString> path. It is the caller's responsibility to delete the directory when done."

	^self newTemporaryDirectory asString!

default: pathString extension: extString
	"Defaults the extension of pathString to extString if there is no current extension.
	Answers the filename with new or existing extension."

	^(pathString asPath withDefaultExtension: extString) asString!

directory: aString
	"Answer a new directory <Path> constructed from the specified path <String>. The directoryName of the new instance will be the argument string, with a path delimiter appended if missing. The fileName will be empty."

	| count |
	count := aString size.
	^self
		fromString: ((count ~~ 0 and: 
					[| last |
					last := aString at: count.
					last == Separator or: [last == UnixSeparator]])
				ifTrue: [aString]
				ifFalse: [aString , SeparatorString])!

empty
	"Answer an empty <Path>"

	^self basicFromString: Utf16String empty!

exists: aPathOrString
	"Answer true if there is a file whose specification is given by aFileName."

	^aPathOrString asPath exists!

find: fileSpec
	"Answer a collection of <WIN32_FIND_DATA>s for each file matching the wildcarded path string, fileSpec. e.g:

		| list |
		list := UI.ListPresenter show.
		list list: ((Path find: '*.*') collect: [:s | s fileName])
	"

	| answer |
	answer := OrderedCollection new.
	self for: fileSpec do: [:s | answer add: s copy].
	^answer!

for: aPathOrString do: operation
	"For each file/directory matching the wildcarded Path/String argument, evaluate the monadic valuable, operation, with a <WIN32_FIND_DATAW> describing the enumerated file/directory as the argument."

	| path |
	path := aPathOrString asPath.
	path directory for: path fileName do: operation!

for: matchString in: dirStringOrPath do: operation
	"For each file/directory matching the wildcarded string argument, matchString, in the directory named, dirString, evaluate the monadic valuable, operation, with a WIN32_FIND_DATA describing the file/directory as the argument."

	dirStringOrPath asPath for: matchString do: operation!

forAll: matchString in: dirStringOrPath do: aMonadicValuable
	"For each file/directory matching the wildcarded string argument, matchString, in the directory named, dirStringOrPath, or one of its sub-directories, evaluate the monadic valuable, aMonadicValuable, with a WIN32_FIND_DATA describing the file/directory as its argument."
	
	dirStringOrPath asPath forAll: matchString do: aMonadicValuable!

forAllDirectories: matchString in: pathString do: operation
	"For each directory whose name matches the wildcarded <readableString> argument,matchString, in the directory identified by the <readableString> or <Path> argument, aStringOrPath, (and recursively below that), evaluate the monadic valuable, aMonadicValuable, passing it a <WIN32_FIND_DATA> describing each matching sub-directory."

	pathString asPath forAllDirectories: matchString do: operation!

forAllDirectoriesIn: aString do: operation
	"For each directory in the directory identified by the <readableString> argument,
	and recursively below that, evaluate the monadic valuable, operation, with a 
	WIN32_FIND_DATA describing the directory as the argument.
	Implementation Note: The tree traversal is pre-order, depth-first."

	^self
		forAllDirectories: '*.*'
		in: aString
		do: operation!

forDirectories: matchString in: dirPathOrString do: operation
	"For each directory in the directory identified by the <Path> or <readableString> argument, dirPathOrString, evaluate the monadic valuable, operation, with a WIN32_FIND_DATA describing the 
	directory as the argument."

	dirPathOrString asPath forDirectories: matchString do: operation!

forDirectoriesIn: aString do: operation
	"For each directory in the directory identified by the <readableString> argument 
	evaluate the monadic valuable, operation, with a WIN32_FIND_DATA describing the 
	directory as the argument."

	^self 
		forDirectories: '*.*'
		in: aString
		do: operation!

fromString: aString
	"Answer a new <Path> constructed from the specified path <String>."

	| path |
	path := (aString ?? '') asUtf16String.
	(path size < MAX_PATH or: [PathCch isLongPathAware or: [path beginsWith: LongPathPrefix]])
		ifFalse: [path := PathCch pathCanonicalize: path dwFlags: PathCchLibrary.PATHCCH_ALLOW_LONG_PATHS].
	^self basicFromString: path!

fullPathOf: aPathOrString
	"Answer a <String> representing the full path of the argument <Path> or <String>"

	^aPathOrString asPath fullPath asString!

fullPathOf: aPathOrString relativeTo: aBasePathOrString
	"Answers a <String> which is the fully qualified path of the <Path> or <String> 1st argument, aPathOrString, relative to the <Path> or <String> 2nd argument., aBasePathOrString. i.e. If the aPathOrString is already a fully qualified path, then the answer is its path string. If on the other hand it is a is a truly relative path, then the fully qualified path answer will be composed from aBasePathOrString."

	^(aPathOrString asPath fullPathRelativeTo: aBasePathOrString) asString!

initialize
	self addClassConstant: 'SeparatorString' value: $\ asUtf16String!

isDirectory: aPathOrString
	"Answer true if there is a directory whose path is given by aString."

	^aPathOrString asPath isDirectory!

isRelativePath: aPathOrString
	"Answers whether the <Path> or <String> argument is a relative path with no absolute components. See [Fully Qualified vs. Relative Paths](https://learn.microsoft.com/en-us/windows/win32/fileio/naming-a-file#fully-qualified-vs-relative-paths).

	The Microsoft documentation does not seem to specify the expected treatment of paths with the long path prefix, '\\?\', but empirically it seems these are always considered absolute. This would be consistent with treatment of UNC paths."

	^aPathOrString isNil or: [aPathOrString asPath isRelative]!

isRootPath: aPathOrString
	"Answer whether the <Path> or <String> argument is a root path, e.g. 'c:\'"

	^aPathOrString notNil and: [aPathOrString asPath isRoot]!

locateFilename: aFilenameString in: searchPath
	"Answers the full pathname of aFilenameString searched for in the ordered collection
	of paths provided in searchPath. If aFilenameString includes a directory then it is
	answered. Otherwise the file is searched for in the directories in searchPath. If the
	file is not found in any of these directories then aFilenameString is answered"

	^(aFilenameString asPath locateIn: searchPath) asString!

make: anArray
	"Answer a new <Path> composed from the drive, path, stem and extension components that are the elements of the <Array> argument, in that order. An error will be raised if the argument does not contain at least 4 elements. Any of the components can be nil or the empty string if not to be specified by the path."

	| size drive dir fname ext path |
	size := 0.
	(anArray at: 1)
		ifNotNil: 
			[:d |
			"Assume the drive doesn't have the colon and that _makepath_s will add it"
			drive := d asUtf8String.
			size := drive size + 1].
	(anArray at: 2)
		ifNotNil: 
			[:d |
			"Assume the terminating path separator is missing"
			dir := d asUtf8String.
			size := size + dir size + 1].
	(anArray at: 3)
		ifNotNil: 
			[:f |
			fname := f asUtf8String.
			size := size + fname size].
	(anArray at: 4)
		ifNotNil: 
			[:e |
			"Assume the dot is missing"
			ext := e asUtf8String.
			size := size + ext size + 1].
	path := Utf8String newFixed: size.
	Ucrt
		_makepath_s: path
		bufferSize: size + 1
		drive: drive
		dir: dir
		fname: fname
		ext: ext.
	^self fromString: path trimNulls!

makePath: anArray
	"Composes a full pathname from its drive, directory, file stem and extension components. The drive, directory, and extension components can be nil or the empty string if the path does not have any of these components. The file stem component must be a non-empty String."

	^(self make: anArray) asString!

newTemporaryDirectory
	"Create a new, unique, temporary directory, and answer it's <readableString> path. It is the caller's responsibility to delete the directory when done."

	| temp |
	temp := self tempDirectory \ (GUID newUnique idlString , SeparatorString).
	temp createDirectory.
	^temp!

path: aPath extension: extString
	"Answer a <Path> pathname composed from the <Path> or <String> first argument, with the <String> 2nd argument as the extension, whether or not aPath already has an extension."

	^(aPath asPath withExtension: extString) asString!

pathDelimiter
	"Answers the character that delimits a path (or parts thereof)"

	^Separator!

relativePathOf: aPathString to: aBasePathString
	"Answers the relative path of aPathString relative to aBasePathString.
	Note that if the last component of aBasePathString is to be considered a directory
	then there must be a trailing slash, otherwise the last component is ignored (it is
	treated as if it were a file name)."

	^(aPathString asPath relativeTo: aBasePathString) asString!

removeExtension: aString
	"Answer a <readableString> which is the path argument with the extension component removed."

	^aString asPath withoutExtension asString!

removePathDelimiter: aString
	"Answer a <readableString> that is the argument with a path separator at its end, if any, removed."

	^aString asPath withoutSeparator asString!

replacePath: filePath with: newPath
	"Replace the path component of the full path name, filePath, with the new path name,
	newPath, i.e. only the stem and extension remain intact."

	| oldPathComponents |
	oldPathComponents := self splitPath: filePath.
	oldPathComponents 
		at: 1 put: nil;			"new path can include drive letter"
		at: 2 put: newPath.
	^self makePath: oldPathComponents!

separator
	"Answers the character that delimits a path (or parts thereof)"

	^Separator!

separators
	"Answers the characters that can be used to delimits a path (or parts thereof). Windows tends to accept the Unix delimiter, a forward slash, as well as its own back slash."

	^Separators!

shortenComponent: aString max: anInteger 
	| abbreviated |
	abbreviated := aString.
	abbreviated size > anInteger ifTrue: [abbreviated := abbreviated select: [:c | c isAlphaNumeric]].
	abbreviated size > anInteger 
		ifTrue: 
			[| len |
			len := abbreviated size.
			abbreviated := abbreviated reverse.
			abbreviated := abbreviated select: 
							[:c | 
							| useChar |
							(c isVowel and: [c isLowercase and: [len > anInteger]]) 
								ifTrue: 
									[useChar := false.
									len := len - 1]
								ifFalse: [useChar := true].
							useChar].
			abbreviated := abbreviated reverse].
	abbreviated size > anInteger 
		ifTrue: 
			[| len |
			len := abbreviated size.
			abbreviated := abbreviated reverse.
			abbreviated := abbreviated select: 
							[:c | 
							| useChar |
							(c isLowerCase and: [len > anInteger]) 
								ifTrue: 
									[useChar := false.
									len := len - 1]
								ifFalse: [useChar := true].
							useChar].
			abbreviated := abbreviated reverse].
	abbreviated size > anInteger ifTrue: [abbreviated := abbreviated leftString: anInteger].
	^abbreviated!

shortPathOf: aPathnameString
	"Answers the short path version of aPathnameString"

	^aPathnameString asPath shortForm asString!

shortStem: stemString extension: extensionString 
	"Answer a new <Path> for an abbreviated filename composed from the at most 8 characters of the file stem specified by the <String> 1st argument, and at most 3 characters from the extension specified by the <String> 2nd argument. Note that the dot separator may be specified in the extension, or not. 
		* Lower case vowels are dropped from the right of the file stem until it is less than or equal to 8 characters.
		* If still longer than 8 chars, then other lowercase letters are dropped from the right of the stem until it is less than or equal to 8 characters."

	| stemResult extResult |
	stemResult := self shortenComponent: stemString asString max: 8.
	extResult := self shortenComponent: extensionString max: 3.
	^self stem: stemResult extension: extResult!

splitDriveFrom: aString
	"Splits the pathname, aString, and answers the drive portion.
	Answers an empty string if there is no drive component in the path."

	^aString asPath drive!

splitExtensionFrom: aString
	"Splits aPathname string and answers the extension portion.
	Answers the empty string if there is no extension."

	^aString asPath extension!

splitFilenameFrom: aString
	"Splits the pathname, aString, and answers the file name portion (including extension).
	Answers an empty string if there is no filename component in the path."

	^aString asPath fileName!

splitPath: aString
	"Splits the pathname, aString, into its path, stem and extension components and answers 
	a four element Array of these.
	Note: We use the C-runtime library to implement this, hence either backward or forward
	slashes (i.e. $\ or $/) are acceptable as pathname delimiters."

	^aString asPath split!

splitStemFrom: aString
	"Answers the file stem component of the path <String> argument, or an empty string if there
	is none."

	^aString asPath stem!

stem: stemString extension: extensionString
	"Answer a new <Path> for a filename composed from the file stem specified by the <String> 1st argument, and the extension specified by the <String> 2nd argument. Note that the dot separator may be specified in the extension, or not."

	"Implementation Note: This could be implemented in terms of #compose:stem:extension:, which ultimately is implemented in terms of #make:, however it is a very frequently used method so an optimized version which takes advantage of private knowledge of how file names are constructed is warranted."

	^self fromString: (extensionString isEmpty
				ifTrue: [stemString]
				ifFalse: 
					[(extensionString at: 1) == ExtensionSeparator
						ifTrue: [stemString asString , extensionString]
						ifFalse: [stemString asString , '.' , extensionString]])!

tempDirectory
	"Answer a <Path> referring to the directory designated for temporary files on the host system."

	^self directory: Kernel32 getTempPath!

temporary
	"Answer a new unique temporary filename in the logged on user's temp directory (see #tempDirectory). Note that this must create the file in order to ensure uniqueness. You are responsible for deleting the file when you have finished with it."
	
	^self temporaryWithPrefix: ''
	!

temporaryFilename
	"Answer a new unique temporary filename in the logged on user's temp directory (see #tempDirectory). Note that this must create the file in order to ensure uniqueness. You are responsible for deleting the file when you have finished with it."

	^self temporary asString!

temporaryFilenameWithPrefix: prefixString
	"Answer a temporary filename built from prefixString in the user's temporary files directory. Note that this will create the temp file in order to guarantee uniqueness. You are responsible for deleting the file when it is no longer required. Signals a Win32Error if the operation fails, e.g. if the tempPath is longer than MAX_PATH-14 as the API does not support long filenames."

	^(self temporaryWithPrefix: prefixString) asString!

temporaryWithPrefix: prefixString
	"Answer a temporary filename built from prefixString in the user's temporary files directory. Note that this will create the temp file in order to guarantee uniqueness. You are responsible for deleting the file when it is no longer required. Signals a Win32Error if the operation fails, e.g. if the tempPath is longer than MAX_PATH-14 as the API does not support long filenames."

	^self
		fromString: (Kernel32 getTempFileName: self tempDirectory asUtf16String lpPrefixString: prefixString)!

windowsDirectory
	"Answer the path of the Windows directory on the host computer for the current session. Note that under Terminal Server this will be the shared Windows directory, not the per-user Windows directory. See MSDN KB281316  for further information."

	^self directory: Kernel32 getSystemWindowsDirectory!

workingDirectory
	"Answer the current working directory. The result always has a trailing separator."

	^self directory: Kernel32 getCurrentDirectory! !

!Core.Path class categoriesForMethods!
appendPathDelimiter:!legacy File api!public! !
attributes:!legacy File api!public! !
basicFromString:!instance creation!public! !
canonicalizePath:!legacy File api!public! !
commonPrefixOf:and:!legacy File api!public! !
compose:stem:extension:!instance creation!public! !
composePath:stem:extension:!legacy File api!public! !
composePath:subPath:!legacy File api!public! !
composeShortStem:extension:!legacy File api!public! !
composeStem:extension:!legacy File api!public! !
createDirectoryPath:!legacy File api!public! !
createTemporaryDirectory!legacy File api!public! !
default:extension:!legacy File api!public! !
directory:!instance creation!public! !
empty!instance creation!public! !
exists:!legacy File api!public! !
find:!legacy File api!public!searching! !
for:do:!enumerating!legacy File api!public! !
for:in:do:!enumerating!legacy File api!public! !
forAll:in:do:!enumerating!legacy File api!public! !
forAllDirectories:in:do:!enumerating!legacy File api!public! !
forAllDirectoriesIn:do:!enumerating!legacy File api!public! !
forDirectories:in:do:!enumerating!legacy File api!public! !
forDirectoriesIn:do:!enumerating!legacy File api!public! !
fromString:!instance creation!public! !
fullPathOf:!legacy File api!public! !
fullPathOf:relativeTo:!legacy File api!public! !
initialize!class initialization!public! !
isDirectory:!legacy File api!public! !
isRelativePath:!legacy File api!public! !
isRootPath:!legacy File api!public! !
locateFilename:in:!legacy File api!public! !
make:!instance creation!public! !
makePath:!legacy File api!public! !
newTemporaryDirectory!file operations!instance creation!public! !
path:extension:!legacy File api!public! !
pathDelimiter!legacy File api!public! !
relativePathOf:to:!legacy File api!public! !
removeExtension:!legacy File api!public! !
removePathDelimiter:!legacy File api!public! !
replacePath:with:!legacy File api!public! !
separator!legacy File api!public! !
separators!legacy File api!public! !
shortenComponent:max:!helpers!private! !
shortPathOf:!legacy File api!public! !
shortStem:extension:!instance creation!public! !
splitDriveFrom:!legacy File api!public! !
splitExtensionFrom:!legacy File api!public! !
splitFilenameFrom:!legacy File api!public! !
splitPath:!legacy File api!public! !
splitStemFrom:!legacy File api!public! !
stem:extension:!instance creation!public! !
tempDirectory!instance creation!public! !
temporary!instance creation!public! !
temporaryFilename!legacy File api!public! !
temporaryFilenameWithPrefix:!legacy File api!public! !
temporaryWithPrefix:!legacy File api!public! !
windowsDirectory!instance creation!public! !
workingDirectory!instance creation!public! !
!

