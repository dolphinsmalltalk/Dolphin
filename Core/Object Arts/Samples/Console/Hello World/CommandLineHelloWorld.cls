"Filed out from Dolphin Smalltalk"!

ConsoleSessionManager subclass: #CommandLineHelloWorld
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CommandLineHelloWorld guid: (GUID fromString: '{3b286201-8b85-46ae-8e1d-ec1ce757d330}')!
CommandLineHelloWorld comment: 'CommandLineHelloWorld is a simple <ConsoleSessionManager> that implements a "Hello World" program entirely in its #main method. It prints the familiar phrase to the standard output stream, along with a prompt for the user to press Enter to finish. When the user has pressed enter the program drops off the end of the #main method and exits.

To test:
	[self run] fork. "Ctrl+E, then Enter to exit"

N.B.  You can safely press Ctrl+C to interrupt/terminate application when deployed as an executable, BUT if you attempt to interrupt the application when testing from the development environment, both may lock up. Attempting to close the console window will initiate a shutdown of the entire system (though this can be cancelled).'!
!CommandLineHelloWorld categoriesForClass!Samples! !
!CommandLineHelloWorld methodsFor!

main
	"Implement the main body of the Headless Hello World application by printing that familiar
	greeting to the standard output stream. Note that international characters are supported,
	but you may need to change the console font in order to see them as the standard console
	fonts have glyphs for only a limited range of code points."

	self stdout 
		nextPutAll: 'Hello World!! 你好'; cr; flush.
	self stderr
		nextPutAll: 'Press <Enter> to exit:'; flush.
	self stdin nextLine! !
!CommandLineHelloWorld categoriesForMethods!
main!operations-startup!public! !
!

