"Filed out from Dolphin Smalltalk 7"!

UI.ValuePresenter subclass: #'UI.URLPresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.URLPresenter guid: (Core.GUID fromString: '{a98215d9-bda9-4b36-8443-c6a72c049d71}')!
UI.URLPresenter comment: ''!
!UI.URLPresenter categoriesForClass!MVP-Presenters! !
!UI.URLPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^'about:blank' copy asValue!

defaultView
	"Answer the resource name of the default view for the receiver."

	^'Internet Explorer'!

resource_Internet_Explorer
	"Answer the literal data from which the 'Internet Explorer' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Internet_Explorer)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.AXValueConvertingControlSite) 34 26 nil nil 34 2 8 1140916224 1 416 918598 2 ##(UI.ValueHolder) nil false 1704454 ##(Core.PluggableSearchPolicy) 786950 ##(Core.Message) #= 8 #() 546 #hash 8 #() nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 416 nil 537194055 8 'Shell.Explorer' 1311750 ##(SHDocVw.IWebBrowser2) nil nil 1902918 1 ##(OS.COM.TKindInterfaceAnalyzer) 1114886 ##(OS.COM.ITypeInfo2) nil nil 983814 ##(OS.COM.TYPEATTR) nil 720 752 nil nil 1706566 3 ##(OS.COM.TypeLibraryAnalyzer) 1049094 ##(OS.COM.ITypeLib2) nil nil 257 1442886 2 ##(Kernel.VariableBinding) #SHDocVw ##(SHDocVw) ##(Root) 1 983302 ##(OS.COM.TLIBATTR) 8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 1508870 ##(Kernel.BindingReference) 8 'SHDocVw' 34 1 976 nil 1 880 6049 8 'Internet Explorer' nil nil 170 176 8 #(#GUID #GUID) nil 589878 ##(Core.GUID) 16 97 22 12 211 175 205 208 17 138 62 0 192 79 201 226 110 11 1770502 ##(OS.COM.TypeLibDocumentation) 8 'IWebBrowser2' 8 'Web Browser Interface for IE4.' 1 8 '' nil nil nil 1114630 ##(UI.IDolphinAxHost) nil nil 1050118 ##(OS.COM.EventSink) 170 176 8 #(268 #ClientToHostWindow:CY: 227 #UpdatePageStatus:nPage:fDone: 106 #DownloadBegin 253 #OnQuit 266 #WindowSetWidth: 225 #PrintTemplateInstantiation: 104 #DownloadComplete 251 #NewWindow2:Cancel: 264 #WindowSetLeft: 290 #BeforeScriptExecute: 102 #StatusTextChange: 262 #WindowSetResizable: 288 #WebWorkerStarted:bstrWorkerLabel: 113 #TitleChange: 260 #OnTheaterMode: 273 #NewWindow3:Cancel:dwFlags:bstrUrlContext:bstrUrl: 286 #RedirectXDomainBlocked:StartURL:RedirectURL:Frame:StatusCode: 258 #OnFullScreen: 271 #NavigateError:URL:Frame:StatusCode:Cancel: 284 #NewProcess:pWB2:Cancel: 256 #OnMenuBar: 269 #SetSecureLockIcon: 282 #SetPhishingFilterStatus: 254 #OnVisible: 267 #WindowSetHeight: 226 #PrintTemplateTeardown: 105 #CommandStateChange:Enable: 252 #NavigateComplete2:URL: 265 #WindowSetTop: 250 #BeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel: 263 #WindowClosing:Cancel: 289 #WebWorkerFinsihed: 112 #PropertyChange: 259 #DocumentComplete:URL: 272 #PrivacyImpactedStateChange: 285 #ThirdPartyUrlBlocked:dwCount: 257 #OnStatusBar: 270 #FileDownload:Cancel: 283 #WindowStateChanged:dwValidFlagsMask: 108 #ProgressChange:ProgressMax: 255 #OnToolBar:) 416 1507846 ##(OS.COM.IConnectionPoint) nil nil 3 1837382 1 ##(OS.COM.TKindDispatchAnalyzer) 738 nil nil 770 nil 1312 1328 nil nil 816 1058 16 160 21 167 52 135 101 208 17 146 74 0 32 175 199 172 77 25 1090 8 'DWebBrowserEvents2' 8 'Web Browser Control events interface' 1 1152 nil nil 1 3787 170 176 8 #() 1704966 ##(UI.IAxWinAmbientDispatchEx) nil nil nil nil 983558 ##(OS.COM.IUnknown) nil nil nil nil nil 1049094 ##(UI.NullConverter) nil nil 1310982 ##(Core.MessageSequence) 138 144 34 4 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 6143 21 1666 1179 289 416 1618 #restoreAmbientProperties 1440 416 1618 #docHostFlags: 8 #(4) 416 1618 #controlBinaryStoreBytes: 34 1 8 #[97 249 86 136 10 52 208 17 169 107 0 192 79 215 5 162 76 0 0 0 224 60 0 0 226 14 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 76 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 224 208 87 0 115 53 207 17 174 105 8 0 43 46 18 98 8 0 0 0 0 0 0 0 76 0 0 0 1 20 2 0 0 0 0 0 192 0 0 0 0 0 0 70 128 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 76 14 0 0 154 0 0 0] 8 #() 1666 193 193 nil 27 )! !
!UI.URLPresenter class categoriesFor: #defaultModel!models!public! !
!UI.URLPresenter class categoriesFor: #defaultView!constants!public! !
!UI.URLPresenter class categoriesFor: #resource_Internet_Explorer!public!resources-views! !

