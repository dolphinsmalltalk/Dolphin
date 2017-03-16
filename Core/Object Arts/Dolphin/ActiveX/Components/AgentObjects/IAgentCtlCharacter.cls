"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IAgentCtlCharacter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlCharacter guid: (IID fromString: '{F5BE8BD9-7DE6-11D0-91FE-00C04FD701A5}')!
IAgentCtlCharacter comment: '<IAgentCtlCharacter> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlCharacter'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlCharacter Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlCharacter categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlCharacter methodsFor!

activate
	"Answer the <VARIANT_BOOL> result of invoking the Activate() method of the COM object.
	Default values are passed for all optional parameters."

	^self activate: VARIANT unspecified!

activate: state
	"Answer the <VARIANT_BOOL> result of invoking the Activate() method of the COM object."

	| answer |
	answer := (VARIANT_BOOL new).
	self
		Activate: state asVariant
		Success: answer.
	^answer asObject
!

Activate: state Success: success
	"Private - Invoke the Activate() method of the COM object.

		HRESULT __stdcall Activate(
			[in, optional] VARIANT State,
			[out, retval] VARIANT_BOOL* Success);"

	<virtual stdcall: hresult 25 variant varbool*>
	^self invalidCall
!

balloon
	"Answer the <IAgentCtlBalloonEx> value of the 'Balloon' property of the receiver."

	| answer |
	answer := IAgentCtlBalloonEx newPointer.
	self get_Balloon: answer.
	^answer asObject
!

commands
	"Answer the <IAgentCtlCommandsEx> value of the 'Commands' property of the receiver."

	| answer |
	answer := IAgentCtlCommandsEx newPointer.
	self get_Commands: answer.
	^answer asObject
!

description
	"Answer the <bstr> value of the 'Description' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Description: answer.
	^answer asObject
!

description: description
	"Set the 'Description' property of the receiver to the <bstr> value of the argument."

	self put_Description: description
!

extent
	^self width @ self height!

extent: aPoint 
	self
		width: aPoint x;
		height: aPoint y!

extraData
	"Answer the <bstr> value of the 'ExtraData' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_ExtraData: answer.
	^answer asObject
!

gestureAt: x y: y
	"Answer the <IAgentCtlRequest> result of invoking the GestureAt() method of the COM object."

	| answer |
	answer := IAgentCtlRequest newPointer.
	self
		GestureAt: x
		y: y
		Request: answer.
	^answer asObject
!

GestureAt: x y: y Request: request
	"Private - Invoke the GestureAt() method of the COM object.

		HRESULT __stdcall GestureAt(
			[in] short x,
			[in] short y,
			[out, retval] IAgentCtlRequest** Request);"

	<virtual stdcall: hresult 32 sword sword IAgentCtlRequest**>
	^self invalidCall
!

get: type name: name
	"Answer the <IAgentCtlRequest> result of invoking the Get() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 get: type
		 name: name
		 queue: VARIANT unspecified!

get: type name: name queue: queue
	"Answer the <IAgentCtlRequest> result of invoking the Get() method of the COM object."

	| answer |
	answer := IAgentCtlRequest newPointer.
	self
		Get: type
		Name: name
		Queue: queue asVariant
		Request: answer.
	^answer asObject
!

Get: type Name: name Queue: queue Request: request
	"Private - Invoke the Get() method of the COM object.

		HRESULT __stdcall Get(
			[in] BSTR Type,
			[in] BSTR Name,
			[in, optional] VARIANT Queue,
			[out, retval] IAgentCtlRequest** Request);"

	<virtual stdcall: hresult 27 bstr bstr variant IAgentCtlRequest**>
	^self invalidCall
!

get_Balloon: ppidBalloon
	"Private - Get the value of the 'Balloon' property of the receiver.
				HRESULT __stdcall Balloon(
			[out, retval] IAgentCtlBalloonEx** ppidBalloon);"

	<virtual stdcall: hresult 8 IAgentCtlBalloonEx**>
	^self invalidCall
!

get_Commands: ppidCommands
	"Private - Get the value of the 'Commands' property of the receiver.
				HRESULT __stdcall Commands(
			[out, retval] IAgentCtlCommandsEx** ppidCommands);"

	<virtual stdcall: hresult 9 IAgentCtlCommandsEx**>
	^self invalidCall
!

get_Description: description
	"Private - Get the value of the 'Description' property of the receiver.
				HRESULT __stdcall Description(
			[out, retval] BSTR* Description);"

	<virtual stdcall: hresult 11 bstr*>
	^self invalidCall
!

get_ExtraData: extraData
	"Private - Get the value of the 'ExtraData' property of the receiver.
				HRESULT __stdcall ExtraData(
			[out, retval] BSTR* ExtraData);"

	<virtual stdcall: hresult 44 bstr*>
	^self invalidCall
!

get_HasOtherClients: hasOtherClients
	"Private - Get the value of the 'HasOtherClients' property of the receiver.
				HRESULT __stdcall HasOtherClients(
			[out, retval] VARIANT_BOOL* HasOtherClients);"

	<virtual stdcall: hresult 39 varbool*>
	^self invalidCall
!

get_Height: height
	"Private - Get the value of the 'Height' property of the receiver.
				HRESULT __stdcall Height(
			[out, retval] short* Height);"

	<virtual stdcall: hresult 18 sword*>
	^self invalidCall
!

get_IdleOn: on
	"Private - Get the value of the 'IdleOn' property of the receiver.
				HRESULT __stdcall IdleOn(
			[out, retval] VARIANT_BOOL* On);"

	<virtual stdcall: hresult 24 varbool*>
	^self invalidCall
!

get_Left: left
	"Private - Get the value of the 'Left' property of the receiver.
				HRESULT __stdcall Left(
			[out, retval] short* Left);"

	<virtual stdcall: hresult 14 sword*>
	^self invalidCall
!

get_MoveCause: moveCause
	"Private - Get the value of the 'MoveCause' property of the receiver.
				HRESULT __stdcall MoveCause(
			[out, retval] short* MoveCause);"

	<virtual stdcall: hresult 37 sword*>
	^self invalidCall
!

get_Name: name
	"Private - Get the value of the 'Name' property of the receiver.
				HRESULT __stdcall Name(
			[out, retval] BSTR* Name);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall
!

get_Pitch: pitch
	"Private - Get the value of the 'Pitch' property of the receiver.
				HRESULT __stdcall Pitch(
			[out, retval] long* Pitch);"

	<virtual stdcall: hresult 22 sdword*>
	^self invalidCall
!

get_SoundEffectsOn: on
	"Private - Get the value of the 'SoundEffectsOn' property of the receiver.
				HRESULT __stdcall SoundEffectsOn(
			[out, retval] VARIANT_BOOL* On);"

	<virtual stdcall: hresult 41 varbool*>
	^self invalidCall
!

get_Speed: speed
	"Private - Get the value of the 'Speed' property of the receiver.
				HRESULT __stdcall Speed(
			[out, retval] long* Speed);"

	<virtual stdcall: hresult 21 sdword*>
	^self invalidCall
!

get_Top: top
	"Private - Get the value of the 'Top' property of the receiver.
				HRESULT __stdcall Top(
			[out, retval] short* Top);"

	<virtual stdcall: hresult 16 sword*>
	^self invalidCall
!

get_VisibilityCause: visibilityCause
	"Private - Get the value of the 'VisibilityCause' property of the receiver.
				HRESULT __stdcall VisibilityCause(
			[out, retval] short* VisibilityCause);"

	<virtual stdcall: hresult 38 sword*>
	^self invalidCall
!

get_Visible: visible
	"Private - Get the value of the 'Visible' property of the receiver.
				HRESULT __stdcall Visible(
			[out, retval] VARIANT_BOOL* Visible);"

	<virtual stdcall: hresult 12 varbool*>
	^self invalidCall
!

get_Width: width
	"Private - Get the value of the 'Width' property of the receiver.
				HRESULT __stdcall Width(
			[out, retval] short* Width);"

	<virtual stdcall: hresult 20 sword*>
	^self invalidCall
!

hasOtherClients
	"Answer the <varbool> value of the 'HasOtherClients' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_HasOtherClients: answer.
	^answer asObject
!

height
	"Answer the <sword> value of the 'Height' property of the receiver."

	| answer |
	answer := (SWORD new).
	self get_Height: answer.
	^answer asObject
!

height: height
	"Set the 'Height' property of the receiver to the <sword> value of the argument."

	self put_Height: height
!

hide
	"Answer the <IAgentCtlRequest> result of invoking the Hide() method of the COM object.
	Default values are passed for all optional parameters."

	^self hide: VARIANT unspecified!

hide: fast
	"Answer the <IAgentCtlRequest> result of invoking the Hide() method of the COM object."

	| answer |
	answer := IAgentCtlRequest newPointer.
	self
		Hide: fast asVariant
		Request: answer.
	^answer asObject
!

Hide: fast Request: request
	"Private - Invoke the Hide() method of the COM object.

		HRESULT __stdcall Hide(
			[in, optional] VARIANT Fast,
			[out, retval] IAgentCtlRequest** Request);"

	<virtual stdcall: hresult 34 variant IAgentCtlRequest**>
	^self invalidCall
!

idleOn
	"Answer the <varbool> value of the 'IdleOn' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_IdleOn: answer.
	^answer asObject
!

idleOn: on
	"Set the 'IdleOn' property of the receiver to the <varbool> value of the argument."

	self put_IdleOn: on
!

interrupt: interruptRequest
	"Answer the <IAgentCtlRequest> result of invoking the Interrupt() method of the COM object."

	| answer |
	answer := IAgentCtlRequest newPointer.
	self
		Interrupt: interruptRequest
		Request: answer.
	^answer asObject
!

Interrupt: interruptRequest Request: request
	"Private - Invoke the Interrupt() method of the COM object.

		HRESULT __stdcall Interrupt(
			[in] IDispatch* InterruptRequest,
			[out, retval] IAgentCtlRequest** Request);"

	<virtual stdcall: hresult 30 IDispatch* IAgentCtlRequest**>
	^self invalidCall
!

left
	"Answer the <sword> value of the 'Left' property of the receiver."

	| answer |
	answer := (SWORD new).
	self get_Left: answer.
	^answer asObject
!

left: left
	"Set the 'Left' property of the receiver to the <sword> value of the argument."

	self put_Left: left
!

moveCause
	"Answer the <sword> value of the 'MoveCause' property of the receiver."

	| answer |
	answer := (SWORD new).
	self get_MoveCause: answer.
	^answer asObject
!

moveTo: aPoint 
	"Move the character to the specified point, answering the <IAgentCtlRequest>."

	^self moveTo: aPoint x y: aPoint y!

moveTo: x y: y
	"Answer the <IAgentCtlRequest> result of invoking the MoveTo() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 moveTo: x
		 y: y
		 speed: VARIANT unspecified!

moveTo: x y: y speed: speed
	"Answer the <IAgentCtlRequest> result of invoking the MoveTo() method of the COM object."

	| answer |
	answer := IAgentCtlRequest newPointer.
	self
		MoveTo: x
		y: y
		Speed: speed asVariant
		Request: answer.
	^answer asObject
!

MoveTo: x y: y Speed: speed Request: request
	"Private - Invoke the MoveTo() method of the COM object.

		HRESULT __stdcall MoveTo(
			[in] short x,
			[in] short y,
			[in, optional] VARIANT Speed,
			[out, retval] IAgentCtlRequest** Request);"

	<virtual stdcall: hresult 33 sword sword variant IAgentCtlRequest**>
	^self invalidCall
!

name
	"Answer the <bstr> value of the 'Name' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Name: answer.
	^answer asObject
!

name: name
	"Set the 'Name' property of the receiver to the <bstr> value of the argument."

	self put_Name: name
!

pitch
	"Answer the <sdword> value of the 'Pitch' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Pitch: answer.
	^answer asObject
!

play: animation
	"Answer the <IAgentCtlRequest> result of invoking the Play() method of the COM object."

	| answer |
	answer := IAgentCtlRequest newPointer.
	self
		Play: animation
		Request: answer.
	^answer asObject
!

play: animation ifAbsent: aBlock
	^[self play: animation] on: Error do: [:e | aBlock value].
!

Play: animation Request: request
	"Private - Invoke the Play() method of the COM object.

		HRESULT __stdcall Play(
			[in] BSTR Animation,
			[out, retval] IAgentCtlRequest** Request);"

	<virtual stdcall: hresult 26 bstr IAgentCtlRequest**>
	^self invalidCall
!

put_Description: description
	"Private - Set the value of the 'Description' property of the object wrapped by the 
	 receiver to the <bstr> argument, description.
				HRESULT __stdcall Description(
			[in] BSTR Description);"

	<virtual stdcall: hresult 43 bstr>
	^self invalidCall
!

put_Height: height
	"Private - Set the value of the 'Height' property of the object wrapped by the 
	 receiver to the <sword> argument, height.
				HRESULT __stdcall Height(
			short Height);"

	<virtual stdcall: hresult 17 sword>
	^self invalidCall
!

put_IdleOn: on
	"Private - Set the value of the 'IdleOn' property of the object wrapped by the 
	 receiver to the <varbool> argument, on.
				HRESULT __stdcall IdleOn(
			VARIANT_BOOL On);"

	<virtual stdcall: hresult 23 varbool>
	^self invalidCall
!

put_Left: left
	"Private - Set the value of the 'Left' property of the object wrapped by the 
	 receiver to the <sword> argument, left.
				HRESULT __stdcall Left(
			short Left);"

	<virtual stdcall: hresult 13 sword>
	^self invalidCall
!

put_Name: name
	"Private - Set the value of the 'Name' property of the object wrapped by the 
	 receiver to the <bstr> argument, name.
				HRESULT __stdcall Name(
			[in] BSTR Name);"

	<virtual stdcall: hresult 42 bstr>
	^self invalidCall
!

put_SoundEffectsOn: on
	"Private - Set the value of the 'SoundEffectsOn' property of the object wrapped by the 
	 receiver to the <varbool> argument, on.
				HRESULT __stdcall SoundEffectsOn(
			VARIANT_BOOL On);"

	<virtual stdcall: hresult 40 varbool>
	^self invalidCall
!

put_Top: top
	"Private - Set the value of the 'Top' property of the object wrapped by the 
	 receiver to the <sword> argument, top.
				HRESULT __stdcall Top(
			short Top);"

	<virtual stdcall: hresult 15 sword>
	^self invalidCall
!

put_Width: width
	"Private - Set the value of the 'Width' property of the object wrapped by the 
	 receiver to the <sword> argument, width.
				HRESULT __stdcall Width(
			short Width);"

	<virtual stdcall: hresult 19 sword>
	^self invalidCall
!

show
	"Answer the <IAgentCtlRequest> result of invoking the Show() method of the COM object.
	Default values are passed for all optional parameters."

	^self show: VARIANT unspecified!

show: fast
	"Answer the <IAgentCtlRequest> result of invoking the Show() method of the COM object."

	| answer |
	answer := IAgentCtlRequest newPointer.
	self
		Show: fast asVariant
		Request: answer.
	^answer asObject
!

Show: fast Request: request
	"Private - Invoke the Show() method of the COM object.

		HRESULT __stdcall Show(
			[in, optional] VARIANT Fast,
			[out, retval] IAgentCtlRequest** Request);"

	<virtual stdcall: hresult 35 variant IAgentCtlRequest**>
	^self invalidCall
!

soundEffectsOn
	"Answer the <varbool> value of the 'SoundEffectsOn' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_SoundEffectsOn: answer.
	^answer asObject
!

soundEffectsOn: on
	"Set the 'SoundEffectsOn' property of the receiver to the <varbool> value of the argument."

	self put_SoundEffectsOn: on
!

speak
	"Answer the <IAgentCtlRequest> result of invoking the Speak() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 speak: VARIANT unspecified
		 url: VARIANT unspecified!

speak: text
	^self speak: text url: VARIANT unspecified!

speak: text url: url
	"Answer the <IAgentCtlRequest> result of invoking the Speak() method of the COM object."

	| answer |
	answer := IAgentCtlRequest newPointer.
	self
		Speak: text asVariant
		Url: url asVariant
		Request: answer.
	^answer asObject
!

Speak: text Url: url Request: request
	"Private - Invoke the Speak() method of the COM object.

		HRESULT __stdcall Speak(
			[in, optional] VARIANT Text,
			[in, optional] VARIANT Url,
			[out, retval] IAgentCtlRequest** Request);"

	<virtual stdcall: hresult 31 variant variant IAgentCtlRequest**>
	^self invalidCall
!

speed
	"Answer the <sdword> value of the 'Speed' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Speed: answer.
	^answer asObject
!

stop
	"Invoke the Stop() method of the COM object.
	Default values are passed for all optional parameters."

	^self stop: VARIANT unspecified!

stop: request
	"Invoke the Stop() method of the COM object."

	^self Stop: request asVariant
!

Stop: request
	"Private - Invoke the Stop() method of the COM object.

		HRESULT __stdcall Stop(
			[in, optional] VARIANT Request);"

	<virtual stdcall: hresult 28 variant>
	^self invalidCall
!

stopAll
	"Invoke the StopAll() method of the COM object.
	Default values are passed for all optional parameters."

	^self stopAll: VARIANT unspecified!

stopAll: types
	"Invoke the StopAll() method of the COM object."

	^self StopAll: types asVariant
!

StopAll: types
	"Private - Invoke the StopAll() method of the COM object.

		HRESULT __stdcall StopAll(
			[in, optional] VARIANT Types);"

	<virtual stdcall: hresult 36 variant>
	^self invalidCall
!

top
	"Answer the <sword> value of the 'Top' property of the receiver."

	| answer |
	answer := (SWORD new).
	self get_Top: answer.
	^answer asObject
!

top: top
	"Set the 'Top' property of the receiver to the <sword> value of the argument."

	self put_Top: top
!

visibilityCause
	"Answer the <sword> value of the 'VisibilityCause' property of the receiver."

	| answer |
	answer := (SWORD new).
	self get_VisibilityCause: answer.
	^answer asObject
!

visible
	"Answer the <varbool> value of the 'Visible' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_Visible: answer.
	^answer asObject
!

wait: waitForRequest
	"Answer the <IAgentCtlRequest> result of invoking the Wait() method of the COM object."

	| answer |
	answer := IAgentCtlRequest newPointer.
	self
		Wait: waitForRequest
		Request: answer.
	^answer asObject
!

Wait: waitForRequest Request: request
	"Private - Invoke the Wait() method of the COM object.

		HRESULT __stdcall Wait(
			[in] IDispatch* WaitForRequest,
			[out, retval] IAgentCtlRequest** Request);"

	<virtual stdcall: hresult 29 IDispatch* IAgentCtlRequest**>
	^self invalidCall
!

width
	"Answer the <sword> value of the 'Width' property of the receiver."

	| answer |
	answer := (SWORD new).
	self get_Width: answer.
	^answer asObject
!

width: width
	"Set the 'Width' property of the receiver to the <sword> value of the argument."

	self put_Width: width
! !
!IAgentCtlCharacter categoriesFor: #activate!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #activate:!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #Activate:Success:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #balloon!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #commands!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #description!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #description:!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #extent!geometry!public! !
!IAgentCtlCharacter categoriesFor: #extent:!geometry!public! !
!IAgentCtlCharacter categoriesFor: #extraData!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #gestureAt:y:!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #GestureAt:y:Request:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get:name:!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #get:name:queue:!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #Get:Name:Queue:Request:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_Balloon:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_Commands:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_Description:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_ExtraData:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_HasOtherClients:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_Height:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_IdleOn:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_Left:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_MoveCause:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_Name:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_Pitch:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_SoundEffectsOn:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_Speed:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_Top:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_VisibilityCause:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_Visible:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #get_Width:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #hasOtherClients!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #height!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #height:!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #hide!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #hide:!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #Hide:Request:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #idleOn!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #idleOn:!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #interrupt:!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #Interrupt:Request:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #left!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #left:!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #moveCause!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #moveTo:!positioning!public! !
!IAgentCtlCharacter categoriesFor: #moveTo:y:!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #moveTo:y:speed:!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #MoveTo:y:Speed:Request:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #name!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #name:!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #pitch!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #play:!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #play:ifAbsent:!methods!public! !
!IAgentCtlCharacter categoriesFor: #Play:Request:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #put_Description:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #put_Height:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #put_IdleOn:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #put_Left:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #put_Name:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #put_SoundEffectsOn:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #put_Top:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #put_Width:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #show!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #show:!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #Show:Request:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #soundEffectsOn!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #soundEffectsOn:!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #speak!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #speak:!methods!public! !
!IAgentCtlCharacter categoriesFor: #speak:url:!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #Speak:Url:Request:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #speed!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #stop!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #stop:!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #Stop:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #stopAll!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #stopAll:!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #StopAll:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #top!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #top:!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #visibilityCause!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #visible!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #wait:!**auto generated**!methods!public! !
!IAgentCtlCharacter categoriesFor: #Wait:Request:!**auto generated**!COM Interfaces-IAgentCtlCharacter!private! !
!IAgentCtlCharacter categoriesFor: #width!**auto generated**!properties!public! !
!IAgentCtlCharacter categoriesFor: #width:!**auto generated**!properties!public! !

!IAgentCtlCharacter class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlCharacter'
		IAgentCtlCharacter defineTemplate"

	self
		defineFunction: #get_Balloon:
			argumentTypes: 'IAgentCtlBalloonEx**';
		defineFunction: #get_Commands:
			argumentTypes: 'IAgentCtlCommandsEx**';
		defineFunction: #get_Name:
			argumentTypes: 'bstr*';
		defineFunction: #get_Description:
			argumentTypes: 'bstr*';
		defineFunction: #get_Visible:
			argumentTypes: 'varbool*';
		defineFunction: #put_Left:
			argumentTypes: 'sword';
		defineFunction: #get_Left:
			argumentTypes: 'sword*';
		defineFunction: #put_Top:
			argumentTypes: 'sword';
		defineFunction: #get_Top:
			argumentTypes: 'sword*';
		defineFunction: #put_Height:
			argumentTypes: 'sword';
		defineFunction: #get_Height:
			argumentTypes: 'sword*';
		defineFunction: #put_Width:
			argumentTypes: 'sword';
		defineFunction: #get_Width:
			argumentTypes: 'sword*';
		defineFunction: #get_Speed:
			argumentTypes: 'sdword*';
		defineFunction: #get_Pitch:
			argumentTypes: 'sdword*';
		defineFunction: #put_IdleOn:
			argumentTypes: 'varbool';
		defineFunction: #get_IdleOn:
			argumentTypes: 'varbool*';
		defineFunction: #Activate:Success:
			argumentTypes: 'variant varbool*';
		defineFunction: #Play:Request:
			argumentTypes: 'bstr IAgentCtlRequest**';
		defineFunction: #Get:Name:Queue:Request:
			argumentTypes: 'bstr bstr variant IAgentCtlRequest**';
		defineFunction: #Stop:
			argumentTypes: 'variant';
		defineFunction: #Wait:Request:
			argumentTypes: 'IDispatch* IAgentCtlRequest**';
		defineFunction: #Interrupt:Request:
			argumentTypes: 'IDispatch* IAgentCtlRequest**';
		defineFunction: #Speak:Url:Request:
			argumentTypes: 'variant variant IAgentCtlRequest**';
		defineFunction: #GestureAt:y:Request:
			argumentTypes: 'sword sword IAgentCtlRequest**';
		defineFunction: #MoveTo:y:Speed:Request:
			argumentTypes: 'sword sword variant IAgentCtlRequest**';
		defineFunction: #Hide:Request:
			argumentTypes: 'variant IAgentCtlRequest**';
		defineFunction: #Show:Request:
			argumentTypes: 'variant IAgentCtlRequest**';
		defineFunction: #StopAll:
			argumentTypes: 'variant';
		defineFunction: #get_MoveCause:
			argumentTypes: 'sword*';
		defineFunction: #get_VisibilityCause:
			argumentTypes: 'sword*';
		defineFunction: #get_HasOtherClients:
			argumentTypes: 'varbool*';
		defineFunction: #put_SoundEffectsOn:
			argumentTypes: 'varbool';
		defineFunction: #get_SoundEffectsOn:
			argumentTypes: 'varbool*';
		defineFunction: #put_Name:
			argumentTypes: 'bstr';
		defineFunction: #put_Description:
			argumentTypes: 'bstr';
		defineFunction: #get_ExtraData:
			argumentTypes: 'bstr*'
!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IAgentCtlCharacter initializeTypeLib"

	typeLib := AgentObjectsLib! !
!IAgentCtlCharacter class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IAgentCtlCharacter class categoriesFor: #icon!constants!public! !
!IAgentCtlCharacter class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

