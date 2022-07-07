﻿"Filed out from Dolphin Smalltalk"!

UI.ShellView subclass: #'Tools.DebuggerShellView'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.DebuggerShellView guid: (Core.GUID fromString: '{46a54a97-6440-41a5-b00d-c69b68f2a410}')!
Tools.DebuggerShellView comment: 'DebuggerShellView is a specialised <ShellView> used by the debugger to ensure that the debugger window will open when invoked following an error opening some other window which leaves the VMs system''s create window hook in an inconsistent state. This is important when the option to disable walkbacks, dropping directly into a debugger instead, is enabled.'!
!Tools.DebuggerShellView categoriesForClass!MVP-Presenters! !