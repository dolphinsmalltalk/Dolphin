"Filed out from Dolphin Smalltalk"!

ConsoleSessionManager subclass: #CommandLineCalculator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CommandLineCalculator guid: (GUID fromString: '{e06581cc-330b-4a39-a7b7-f2993822766f}')!

CommandLineCalculator comment: 'Calculator is a sample console application which illustrates the use of the Dolphin Compiler class in a runtime application. See the package comment for more details.

To test:
	[self run] fork. "Ctrl+E. Then Ctrl+Z, Enter to exit"

N.B.  You can safely press Ctrl+C to interrupt/terminate application when deployed as an executable, but if you attempt to interrupt the application when testing from the development environment, both may lock up.'!

!CommandLineCalculator categoriesForClass!Samples! !

!CommandLineCalculator methodsFor!

main
	"Implement the main body of the command line version of the Calculator application."

	| expr |
	(self stdout)
		nextPutAll: 'Dolphin Smalltalk Console Calculator Sample';
		cr;
		nextPutAll: 'Copyright (c) Object Arts Ltd, 2001-2004.';
		cr.
	
	[(self stdout)
		cr;
		nextPutAll: '> ';
		flush.
	expr := self stdin nextLine.
	expr isEmpty and: [self stdin atEnd]] 
			whileFalse: 
				[
				[(self stdout)
					display: (Compiler evaluate: expr);
					cr;
					flush] 
						on: Compiler errorClass , Error
						do: 
							[:x | 
							(self stderr)
								display: x;
								cr;
								flush]]! !

!CommandLineCalculator categoriesForMethods!
main!operations-startup!public! !
!

