"Filed out from Dolphin Smalltalk"!

External.WindowsSystemLibrary
	subclass: #'OS.UserLibrary'
	instanceVariableNames: ''
	classVariableNames: 'DesiredDpiAwarenessContext DpiAwarenessContext'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'AW_ACTIVATE' -> 16r20000.
			'AW_BLEND' -> 16r80000.
			'AW_CENTER' -> 16r10.
			'AW_HIDE' -> 16r10000.
			'AW_HOR_NEGATIVE' -> 16r2.
			'AW_HOR_POSITIVE' -> 16r1.
			'AW_SLIDE' -> 16r40000.
			'AW_VER_NEGATIVE' -> 16r8.
			'AW_VER_POSITIVE' -> 16r4.
			'BF_ADJUST' -> 16r2000.
			'BF_BOTTOM' -> 16r8.
			'BF_BOTTOMLEFT' -> 16r9.
			'BF_BOTTOMRIGHT' -> 16rC.
			'BF_DIAGONAL' -> 16r10.
			'BF_DIAGONAL_ENDBOTTOMLEFT' -> 16r19.
			'BF_DIAGONAL_ENDBOTTOMRIGHT' -> 16r1C.
			'BF_DIAGONAL_ENDTOPLEFT' -> 16r13.
			'BF_DIAGONAL_ENDTOPRIGHT' -> 16r16.
			'BF_FLAT' -> 16r4000.
			'BF_LEFT' -> 16r1.
			'BF_MIDDLE' -> 16r800.
			'BF_MONO' -> 16r8000.
			'BF_RECT' -> 16rF.
			'BF_RIGHT' -> 16r4.
			'BF_SOFT' -> 16r1000.
			'BF_TOP' -> 16r2.
			'BF_TOPLEFT' -> 16r3.
			'BF_TOPRIGHT' -> 16r6.
			'CS_BYTEALIGNCLIENT' -> 16r1000.
			'CS_BYTEALIGNWINDOW' -> 16r2000.
			'CS_CLASSDC' -> 16r40.
			'CS_DBLCLKS' -> 16r8.
			'CS_GLOBALCLASS' -> 16r4000.
			'CS_HREDRAW' -> 16r2.
			'CS_KEYCVTWINDOW' -> 16r4.
			'CS_NOCLOSE' -> 16r200.
			'CS_NOKEYCVT' -> 16r100.
			'CS_OWNDC' -> 16r20.
			'CS_PARENTDC' -> 16r80.
			'CS_SAVEBITS' -> 16r800.
			'CS_VREDRAW' -> 16r1.
			'CWP_ALL' -> 16r0.
			'CWP_SKIPDISABLED' -> 16r2.
			'CWP_SKIPINVISIBLE' -> 16r1.
			'CWP_SKIPTRANSPARENT' -> 16r4.
			'DDC_DEFAULT' -> 16r0.
			'DDC_DISABLE_ALL' -> 16r1.
			'DDC_DISABLE_CONTROL_RELAYOUT' -> 16r4.
			'DDC_DISABLE_RESIZE' -> 16r2.
			'DFC_BUTTON' -> 16r4.
			'DFC_CAPTION' -> 16r1.
			'DFC_MENU' -> 16r2.
			'DFC_POPUPMENU' -> 16r5.
			'DFC_SCROLL' -> 16r3.
			'DFCS_ADJUSTRECT' -> 16r2000.
			'DFCS_BUTTON3STATE' -> 16r8.
			'DFCS_BUTTONCHECK' -> 16r0.
			'DFCS_BUTTONPUSH' -> 16r10.
			'DFCS_BUTTONRADIO' -> 16r4.
			'DFCS_BUTTONRADIOIMAGE' -> 16r1.
			'DFCS_BUTTONRADIOMASK' -> 16r2.
			'DFCS_CAPTIONCLOSE' -> 16r0.
			'DFCS_CAPTIONHELP' -> 16r4.
			'DFCS_CAPTIONMAX' -> 16r2.
			'DFCS_CAPTIONMIN' -> 16r1.
			'DFCS_CAPTIONRESTORE' -> 16r3.
			'DFCS_CHECKED' -> 16r400.
			'DFCS_FLAT' -> 16r4000.
			'DFCS_INACTIVE' -> 16r100.
			'DFCS_MENUARROW' -> 16r0.
			'DFCS_MENUARROWRIGHT' -> 16r4.
			'DFCS_MENUBULLET' -> 16r2.
			'DFCS_MENUCHECK' -> 16r1.
			'DFCS_MONO' -> 16r8000.
			'DFCS_PUSHED' -> 16r200.
			'DFCS_SCROLLCOMBOBOX' -> 16r5.
			'DFCS_SCROLLDOWN' -> 16r1.
			'DFCS_SCROLLLEFT' -> 16r2.
			'DFCS_SCROLLRIGHT' -> 16r3.
			'DFCS_SCROLLSIZEGRIP' -> 16r8.
			'DFCS_SCROLLSIZEGRIPRIGHT' -> 16r10.
			'DFCS_SCROLLUP' -> 16r0.
			'DI_COMPAT' -> 16r4.
			'DI_DEFAULTSIZE' -> 16r8.
			'DI_IMAGE' -> 16r2.
			'DI_MASK' -> 16r1.
			'DI_NORMAL' -> 16r3.
			'DLGC_BUTTON' -> 16r2000.
			'DLGC_DEFPUSHBUTTON' -> 16r10.
			'DLGC_HASSETSEL' -> 16r8.
			'DLGC_RADIOBUTTON' -> 16r40.
			'DLGC_STATIC' -> 16r100.
			'DLGC_UNDEFPUSHBUTTON' -> 16r20.
			'DLGC_WANTALLKEYS' -> 16r4.
			'DLGC_WANTARROWS' -> 16r1.
			'DLGC_WANTCHARS' -> 16r80.
			'DLGC_WANTMESSAGE' -> 16r4.
			'DLGC_WANTTAB' -> 16r2.
			'DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE' -> -16r3.
			'DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2' -> -16r4.
			'DPI_AWARENESS_CONTEXT_SYSTEM_AWARE' -> -16r2.
			'DPI_AWARENESS_CONTEXT_UNAWARE' -> -16r1.
			'DPI_AWARENESS_CONTEXT_UNAWARE_GDISCALED' -> -16r5.
			'DPI_AWARENESS_INVALID' -> -16r1.
			'DPI_AWARENESS_PER_MONITOR_AWARE' -> 16r2.
			'DPI_AWARENESS_SYSTEM_AWARE' -> 16r1.
			'DPI_AWARENESS_UNAWARE' -> 16r0.
			'DPI_HOSTING_BEHAVIOR_DEFAULT' -> 16r0.
			'DPI_HOSTING_BEHAVIOR_INVALID' -> -16r1.
			'DPI_HOSTING_BEHAVIOR_MIXED' -> 16r1.
			'DSS_DISABLED' -> 16r20.
			'DSS_HIDEPREFIX' -> 16r200.
			'DSS_MONO' -> 16r80.
			'DSS_NORMAL' -> 16r0.
			'DSS_PREFIXONLY' -> 16r400.
			'DSS_RIGHT' -> 16r8000.
			'DSS_UNION' -> 16r10.
			'DST_BITMAP' -> 16r4.
			'DST_COMPLEX' -> 16r0.
			'DST_ICON' -> 16r3.
			'DST_PREFIXTEXT' -> 16r2.
			'DST_TEXT' -> 16r1.
			'DT_BOTTOM' -> 16r8.
			'DT_CALCRECT' -> 16r400.
			'DT_CENTER' -> 16r1.
			'DT_EDITCONTROL' -> 16r2000.
			'DT_END_ELLIPSIS' -> 16r8000.
			'DT_EXPANDTABS' -> 16r40.
			'DT_EXTERNALLEADING' -> 16r200.
			'DT_HIDEPREFIX' -> 16r100000.
			'DT_INTERNAL' -> 16r1000.
			'DT_LEFT' -> 16r0.
			'DT_MODIFYSTRING' -> 16r10000.
			'DT_NOCLIP' -> 16r100.
			'DT_NOFULLWIDTHCHARBREAK' -> 16r80000.
			'DT_NOPREFIX' -> 16r800.
			'DT_PATH_ELLIPSIS' -> 16r4000.
			'DT_PREFIXONLY' -> 16r200000.
			'DT_RIGHT' -> 16r2.
			'DT_RTLREADING' -> 16r20000.
			'DT_SINGLELINE' -> 16r20.
			'DT_TABSTOP' -> 16r80.
			'DT_TOP' -> 16r0.
			'DT_VCENTER' -> 16r4.
			'DT_WORD_ELLIPSIS' -> 16r40000.
			'DT_WORDBREAK' -> 16r10.
			'DWL_MSGRESULT' -> 16r0.
			'EDGE_BUMP' -> 16r9.
			'EDGE_ETCHED' -> 16r6.
			'EDGE_RAISED' -> 16r5.
			'EDGE_SUNKEN' -> 16rA.
			'ESB_DISABLE_BOTH' -> 16r3.
			'ESB_DISABLE_LTUP' -> 16r1.
			'ESB_DISABLE_RTDN' -> 16r2.
			'ESB_ENABLE_BOTH' -> 16r0.
			'FALT' -> 16r10.
			'FCONTROL' -> 16r8.
			'FSHIFT' -> 16r4.
			'FVIRTKEY' -> 16r1.
			'GA_PARENT' -> 16r1.
			'GA_ROOT' -> 16r2.
			'GA_ROOTOWNER' -> 16r3.
			'GCW_ATOM' -> -16r20.
			'GW_HWNDCHILD' -> 16r5.
			'GW_HWNDFIRST' -> 16r0.
			'GW_HWNDLAST' -> 16r1.
			'GW_HWNDNEXT' -> 16r2.
			'GW_HWNDOWNER' -> 16r4.
			'GW_HWNDPREV' -> 16r3.
			'GWL_EXSTYLE' -> -16r14.
			'GWL_ID' -> -16rC.
			'GWL_STYLE' -> -16r10.
			'GWL_WNDPROC' -> -16r4.
			'GWLP_HINSTANCE' -> -16r6.
			'GWLP_HWNDPARENT' -> -16r8.
			'GWLP_ID' -> -16rC.
			'GWLP_WNDPROC' -> -16r4.
			'HTBORDER' -> 16r12.
			'HTBOTTOM' -> 16rF.
			'HTBOTTOMLEFT' -> 16r10.
			'HTBOTTOMRIGHT' -> 16r11.
			'HTCAPTION' -> 16r2.
			'HTCLIENT' -> 16r1.
			'HTERROR' -> -16r2.
			'HTLEFT' -> 16rA.
			'HTRIGHT' -> 16rB.
			'HTTOP' -> 16rC.
			'HTTOPLEFT' -> 16rD.
			'HTTOPRIGHT' -> 16rE.
			'HTTRANSPARENT' -> -16r1.
			'HWND_BOTTOM' -> 16r1.
			'HWND_MESSAGE' -> -16r3.
			'HWND_NOTOPMOST' -> -16r2.
			'HWND_TOP' -> 16r0.
			'HWND_TOPMOST' -> -16r1.
			'IDABORT' -> 16r3.
			'IDCANCEL' -> 16r2.
			'IDCLOSE' -> 16r8.
			'IDCONTINUE' -> 16rB.
			'IDHELP' -> 16r9.
			'IDIGNORE' -> 16r5.
			'IDNO' -> 16r7.
			'IDOK' -> 16r1.
			'IDRETRY' -> 16r4.
			'IDTRYAGAIN' -> 16rA.
			'IDYES' -> 16r6.
			'KF_EXTENDED' -> 16r100.
			'LR_COLOR' -> 16r2.
			'LR_COPYDELETEORG' -> 16r8.
			'LR_COPYFROMRESOURCE' -> 16r4000.
			'LR_COPYRETURNORG' -> 16r4.
			'LR_CREATEDIBSECTION' -> 16r2000.
			'LR_DEFAULTCOLOR' -> 16r0.
			'LR_DEFAULTSIZE' -> 16r40.
			'LR_LOADFROMFILE' -> 16r10.
			'LR_LOADMAP3DCOLORS' -> 16r1000.
			'LR_LOADTRANSPARENT' -> 16r20.
			'LR_MONOCHROME' -> 16r1.
			'LR_SHARED' -> 16r8000.
			'LR_VGACOLOR' -> 16r80.
			'MB_ABORTRETRYIGNORE' -> 16r2.
			'MB_APPLMODAL' -> 16r0.
			'MB_CANCELTRYCONTINUE' -> 16r6.
			'MB_DEFBUTTON1' -> 16r0.
			'MB_DEFBUTTON2' -> 16r100.
			'MB_DEFBUTTON3' -> 16r200.
			'MB_DEFBUTTON4' -> 16r300.
			'MB_DEFMASK' -> 16rF00.
			'MB_HELP' -> 16r4000.
			'MB_ICONERROR' -> 16r10.
			'MB_ICONINFORMATION' -> 16r40.
			'MB_ICONMASK' -> 16rF0.
			'MB_ICONQUESTION' -> 16r20.
			'MB_ICONWARNING' -> 16r30.
			'MB_MISCMASK' -> 16rC000.
			'MB_MODEMASK' -> 16r3000.
			'MB_OK' -> 16r0.
			'MB_OKCANCEL' -> 16r1.
			'MB_RETRYCANCEL' -> 16r5.
			'MB_SETFOREGROUND' -> 16r10000.
			'MB_SYSTEMMODAL' -> 16r1000.
			'MB_TASKMODAL' -> 16r2000.
			'MB_TOPMOST' -> 16r40000.
			'MB_TYPEMASK' -> 16rF.
			'MB_USERICON' -> 16r80.
			'MB_YESNO' -> 16r4.
			'MB_YESNOCANCEL' -> 16r3.
			'MK_CONTROL' -> 16r8.
			'MK_LBUTTON' -> 16r1.
			'MK_MBUTTON' -> 16r10.
			'MK_RBUTTON' -> 16r2.
			'MK_SHIFT' -> 16r4.
			'MK_XBUTTON1' -> 16r20.
			'MK_XBUTTON2' -> 16r40.
			'MOD_ALT' -> 16r1.
			'MOD_CONTROL' -> 16r2.
			'MOD_SHIFT' -> 16r4.
			'MOD_WIN' -> 16r8.
			'MWMO_ALERTABLE' -> 16r2.
			'MWMO_INPUTAVAILABLE' -> 16r4.
			'MWMO_WAITALL' -> 16r1.
			'PM_NOREMOVE' -> 16r0.
			'PM_REMOVE' -> 16r1.
			'PRF_CHECKVISIBLE' -> 16r1.
			'PRF_CHILDREN' -> 16r10.
			'PRF_CLIENT' -> 16r4.
			'PRF_ERASEBKGND' -> 16r8.
			'PRF_NONCLIENT' -> 16r2.
			'PRF_OWNED' -> 16r20.
			'QS_ALLEVENTS' -> 16r1CBF.
			'QS_ALLINPUT' -> 16r1CFF.
			'QS_ALLPOSTMESSAGE' -> 16r100.
			'QS_HOTKEY' -> 16r80.
			'QS_INPUT' -> 16r1C07.
			'QS_KEY' -> 16r1.
			'QS_MOUSE' -> 16r6.
			'QS_MOUSEBUTTON' -> 16r4.
			'QS_MOUSEMOVE' -> 16r2.
			'QS_PAINT' -> 16r20.
			'QS_POINTER' -> 16r1000.
			'QS_POSTMESSAGE' -> 16r8.
			'QS_RAWINPUT' -> 16r400.
			'QS_SENDMESSAGE' -> 16r40.
			'QS_TIMER' -> 16r10.
			'QS_TOUCH' -> 16r800.
			'SB_CTL' -> 16r2.
			'SB_HORZ' -> 16r0.
			'SB_VERT' -> 16r1.
			'SC_CLOSE' -> 16rF060.
			'SM_CXICON' -> 16rB.
			'SM_CXSMICON' -> 16r31.
			'SM_CYICON' -> 16rC.
			'SM_CYSMICON' -> 16r32.
			'SW_ERASE' -> 16r4.
			'SW_HIDE' -> 16r0.
			'SW_INVALIDATE' -> 16r2.
			'SW_MAX' -> 16rA.
			'SW_MAXIMIZE' -> 16r3.
			'SW_MINIMIZE' -> 16r6.
			'SW_NORMAL' -> 16r1.
			'SW_RESTORE' -> 16r9.
			'SW_SCROLLCHILDREN' -> 16r1.
			'SW_SHOW' -> 16r5.
			'SW_SHOWDEFAULT' -> 16rA.
			'SW_SHOWMAXIMIZED' -> 16r3.
			'SW_SHOWMINIMIZED' -> 16r2.
			'SW_SHOWMINNOACTIVE' -> 16r7.
			'SW_SHOWNA' -> 16r8.
			'SW_SHOWNOACTIVATE' -> 16r4.
			'SW_SHOWNORMAL' -> 16r1.
			'SWP_FRAMECHANGED' -> 16r20.
			'SWP_HIDEWINDOW' -> 16r80.
			'SWP_NOACTIVATE' -> 16r10.
			'SWP_NOCOPYBITS' -> 16r100.
			'SWP_NOMOVE' -> 16r2.
			'SWP_NOOWNERZORDER' -> 16r200.
			'SWP_NOREDRAW' -> 16r8.
			'SWP_NOSENDCHANGING' -> 16r400.
			'SWP_NOSIZE' -> 16r1.
			'SWP_NOZORDER' -> 16r4.
			'SWP_SHOWWINDOW' -> 16r40.
			'UIS_CLEAR' -> 16r2.
			'UIS_INITIALIZE' -> 16r3.
			'UIS_SET' -> 16r1.
			'UISF_ACTIVE' -> 16r4.
			'UISF_HIDEACCEL' -> 16r2.
			'UISF_HIDEFOCUS' -> 16r1.
			'USER_DEFAULT_SCREEN_DPI' -> 16r60.
			'VK_ADD' -> 16r6B.
			'VK_APPS' -> 16r5D.
			'VK_BACK' -> 16r8.
			'VK_CANCEL' -> 16r3.
			'VK_CAPITAL' -> 16r14.
			'VK_CLEAR' -> 16rC.
			'VK_CONTROL' -> 16r11.
			'VK_DECIMAL' -> 16r6E.
			'VK_DELETE' -> 16r2E.
			'VK_DIVIDE' -> 16r6F.
			'VK_DOWN' -> 16r28.
			'VK_END' -> 16r23.
			'VK_ESCAPE' -> 16r1B.
			'VK_EXECUTE' -> 16r2B.
			'VK_F1' -> 16r70.
			'VK_F10' -> 16r79.
			'VK_F11' -> 16r7A.
			'VK_F12' -> 16r7B.
			'VK_F2' -> 16r71.
			'VK_F3' -> 16r72.
			'VK_F4' -> 16r73.
			'VK_F5' -> 16r74.
			'VK_F6' -> 16r75.
			'VK_F7' -> 16r76.
			'VK_F8' -> 16r77.
			'VK_F9' -> 16r78.
			'VK_HOME' -> 16r24.
			'VK_INSERT' -> 16r2D.
			'VK_LBUTTON' -> 16r1.
			'VK_LEFT' -> 16r25.
			'VK_LSHIFT' -> 16rA0.
			'VK_LWIN' -> 16r5B.
			'VK_MBUTTON' -> 16r4.
			'VK_MENU' -> 16r12.
			'VK_MULTIPLY' -> 16r6A.
			'VK_NEXT' -> 16r22.
			'VK_NUMLOCK' -> 16r90.
			'VK_NUMPAD0' -> 16r60.
			'VK_NUMPAD1' -> 16r61.
			'VK_NUMPAD2' -> 16r62.
			'VK_NUMPAD3' -> 16r63.
			'VK_NUMPAD4' -> 16r64.
			'VK_NUMPAD5' -> 16r65.
			'VK_NUMPAD6' -> 16r66.
			'VK_NUMPAD7' -> 16r67.
			'VK_NUMPAD8' -> 16r68.
			'VK_NUMPAD9' -> 16r69.
			'VK_OEM_1' -> 16rBA.
			'VK_OEM_2' -> 16rBF.
			'VK_OEM_3' -> 16rC0.
			'VK_OEM_4' -> 16rDB.
			'VK_OEM_5' -> 16rDC.
			'VK_OEM_6' -> 16rDD.
			'VK_OEM_7' -> 16rDE.
			'VK_OEM_8' -> 16rDF.
			'VK_OEM_COMMA' -> 16rBC.
			'VK_OEM_MINUS' -> 16rBD.
			'VK_OEM_PERIOD' -> 16rBE.
			'VK_OEM_PLUS' -> 16rBB.
			'VK_PAUSE' -> 16r13.
			'VK_PRINT' -> 16r2A.
			'VK_PRIOR' -> 16r21.
			'VK_RBUTTON' -> 16r2.
			'VK_RETURN' -> 16rD.
			'VK_RIGHT' -> 16r27.
			'VK_RMENU' -> 16rA5.
			'VK_RWIN' -> 16r5C.
			'VK_SCROLL' -> 16r91.
			'VK_SELECT' -> 16r29.
			'VK_SHIFT' -> 16r10.
			'VK_SNAPSHOT' -> 16r2C.
			'VK_SPACE' -> 16r20.
			'VK_SUBTRACT' -> 16r6D.
			'VK_TAB' -> 16r9.
			'VK_UP' -> 16r26.
			'VK_XBUTTON1' -> 16r5.
			'VK_XBUTTON2' -> 16r6.
			'WA_ACTIVE' -> 16r1.
			'WA_CLICKACTIVE' -> 16r2.
			'WA_INACTIVE' -> 16r0.
			'WM_ACTIVATE' -> 16r6.
			'WM_ACTIVATEAPP' -> 16r1C.
			'WM_APP' -> 16r8000.
			'WM_BEGINDRAG' -> 16r22C.
			'WM_CANCELJOURNAL' -> 16r4B.
			'WM_CANCELMODE' -> 16r1F.
			'WM_CAPTURECHANGED' -> 16r215.
			'WM_CHANGECBCHAIN' -> 16r30D.
			'WM_CHANGEUISTATE' -> 16r127.
			'WM_CHAR' -> 16r102.
			'WM_CHARTOITEM' -> 16r2F.
			'WM_CHILDACTIVATE' -> 16r22.
			'WM_CLEAR' -> 16r303.
			'WM_CLOSE' -> 16r10.
			'WM_COMMAND' -> 16r111.
			'WM_COMMNOTIFY' -> 16r44.
			'WM_COMPACTING' -> 16r41.
			'WM_COMPAREITEM' -> 16r39.
			'WM_CONTEXTMENU' -> 16r7B.
			'WM_COPY' -> 16r301.
			'WM_COPYDATA' -> 16r4A.
			'WM_CREATE' -> 16r1.
			'WM_CTLCOLORBTN' -> 16r135.
			'WM_CTLCOLORDLG' -> 16r136.
			'WM_CTLCOLOREDIT' -> 16r133.
			'WM_CTLCOLORMSGBOX' -> 16r132.
			'WM_CTLCOLORSTATIC' -> 16r138.
			'WM_CUT' -> 16r300.
			'WM_DDE_INITIATE' -> 16r3E0.
			'WM_DEADCHAR' -> 16r103.
			'WM_DELETEITEM' -> 16r2D.
			'WM_DESTROY' -> 16r2.
			'WM_DESTROYCLIPBOARD' -> 16r307.
			'WM_DEVICECHANGE' -> 16r219.
			'WM_DEVMODECHANGE' -> 16r1B.
			'WM_DISPLAYCHANGE' -> 16r7E.
			'WM_DPICHANGED' -> 16r2E0.
			'WM_DPICHANGED_AFTERPARENT' -> 16r2E3.
			'WM_DPICHANGED_BEFOREPARENT' -> 16r2E2.
			'WM_DRAWCLIPBOARD' -> 16r308.
			'WM_DRAWITEM' -> 16r2B.
			'WM_DROPFILES' -> 16r233.
			'WM_ENABLE' -> 16rA.
			'WM_ENDSESSION' -> 16r16.
			'WM_ENTERIDLE' -> 16r121.
			'WM_ENTERMENULOOP' -> 16r211.
			'WM_ENTERSIZEMOVE' -> 16r231.
			'WM_ERASEBKGND' -> 16r14.
			'WM_EXITMENULOOP' -> 16r212.
			'WM_EXITSIZEMOVE' -> 16r232.
			'WM_FONTCHANGE' -> 16r1D.
			'WM_GETDLGCODE' -> 16r87.
			'WM_GETDPISCALEDSIZE' -> 16r2E4.
			'WM_GETFONT' -> 16r31.
			'WM_GETHOTKEY' -> 16r33.
			'WM_GETICON' -> 16r7F.
			'WM_GETMINMAXINFO' -> 16r24.
			'WM_GETTEXT' -> 16rD.
			'WM_GETTEXTLENGTH' -> 16rE.
			'WM_HELP' -> 16r53.
			'WM_HOTKEY' -> 16r312.
			'WM_HSCROLL' -> 16r114.
			'WM_HSCROLLCLIPBOARD' -> 16r30E.
			'WM_ICONERASEBKGND' -> 16r27.
			'WM_IDLEUPDATECMDUI' -> 16r363.
			'WM_INITDIALOG' -> 16r110.
			'WM_INITMENU' -> 16r116.
			'WM_INITMENUPOPUP' -> 16r117.
			'WM_INPUTLANGCHANGE' -> 16r51.
			'WM_INPUTLANGCHANGEREQUEST' -> 16r50.
			'WM_KEYDOWN' -> 16r100.
			'WM_KEYFIRST' -> 16r100.
			'WM_KEYLAST' -> 16r108.
			'WM_KEYUP' -> 16r101.
			'WM_KILLFOCUS' -> 16r8.
			'WM_LBUTTONDBLCLK' -> 16r203.
			'WM_LBUTTONDOWN' -> 16r201.
			'WM_LBUTTONUP' -> 16r202.
			'WM_MBUTTONDBLCLK' -> 16r209.
			'WM_MBUTTONDOWN' -> 16r207.
			'WM_MBUTTONUP' -> 16r208.
			'WM_MEASUREITEM' -> 16r2C.
			'WM_MENUCHAR' -> 16r120.
			'WM_MENUCOMMAND' -> 16r126.
			'WM_MENUSELECT' -> 16r11F.
			'WM_MOUSEACTIVATE' -> 16r21.
			'WM_MOUSEFIRST' -> 16r200.
			'WM_MOUSEHOVER' -> 16r2A1.
			'WM_MOUSEHWHEEL' -> 16r20E.
			'WM_MOUSELAST' -> 16r20E.
			'WM_MOUSELEAVE' -> 16r2A3.
			'WM_MOUSEMOVE' -> 16r200.
			'WM_MOUSEWHEEL' -> 16r20A.
			'WM_MOVE' -> 16r3.
			'WM_MOVING' -> 16r216.
			'WM_NCACTIVATE' -> 16r86.
			'WM_NCCALCSIZE' -> 16r83.
			'WM_NCCREATE' -> 16r81.
			'WM_NCDESTROY' -> 16r82.
			'WM_NCHITTEST' -> 16r84.
			'WM_NCLBUTTONDBLCLK' -> 16rA3.
			'WM_NCLBUTTONDOWN' -> 16rA1.
			'WM_NCLBUTTONUP' -> 16rA2.
			'WM_NCMBUTTONDBLCLK' -> 16rA9.
			'WM_NCMBUTTONDOWN' -> 16rA7.
			'WM_NCMBUTTONUP' -> 16rA8.
			'WM_NCMOUSEMOVE' -> 16rA0.
			'WM_NCPAINT' -> 16r85.
			'WM_NCRBUTTONDBLCLK' -> 16rA6.
			'WM_NCRBUTTONDOWN' -> 16rA4.
			'WM_NCRBUTTONUP' -> 16rA5.
			'WM_NEXTDLGCTL' -> 16r28.
			'WM_NEXTMENU' -> 16r213.
			'WM_NOTIFY' -> 16r4E.
			'WM_NOTIFYFORMAT' -> 16r55.
			'WM_NULL' -> 16r0.
			'WM_PAINT' -> 16rF.
			'WM_PAINTCLIPBOARD' -> 16r309.
			'WM_PAINTICON' -> 16r26.
			'WM_PALETTECHANGED' -> 16r311.
			'WM_PALETTEISCHANGING' -> 16r310.
			'WM_PARENTNOTIFY' -> 16r210.
			'WM_PASTE' -> 16r302.
			'WM_POWER' -> 16r48.
			'WM_POWERBROADCAST' -> 16r218.
			'WM_PRINT' -> 16r317.
			'WM_PRINTCLIENT' -> 16r318.
			'WM_QUERYDRAGICON' -> 16r37.
			'WM_QUERYENDSESSION' -> 16r11.
			'WM_QUERYNEWPALETTE' -> 16r30F.
			'WM_QUERYOPEN' -> 16r13.
			'WM_QUERYUISTATE' -> 16r129.
			'WM_QUEUESYNC' -> 16r23.
			'WM_QUIT' -> 16r12.
			'WM_RBUTTONDBLCLK' -> 16r206.
			'WM_RBUTTONDOWN' -> 16r204.
			'WM_RBUTTONUP' -> 16r205.
			'WM_RENDERALLFORMATS' -> 16r306.
			'WM_RENDERFORMAT' -> 16r305.
			'WM_SETCURSOR' -> 16r20.
			'WM_SETEVENTMASK' -> 16r445.
			'WM_SETFOCUS' -> 16r7.
			'WM_SETFONT' -> 16r30.
			'WM_SETREDRAW' -> 16rB.
			'WM_SETTEXT' -> 16rC.
			'WM_SETTINGCHANGE' -> 16r1A.
			'WM_SHOWWINDOW' -> 16r18.
			'WM_SIZE' -> 16r5.
			'WM_SIZECLIPBOARD' -> 16r30B.
			'WM_SIZING' -> 16r214.
			'WM_SPOOLERSTATUS' -> 16r2A.
			'WM_STYLECHANGED' -> 16r7D.
			'WM_STYLECHANGING' -> 16r7C.
			'WM_SYSCHAR' -> 16r106.
			'WM_SYSCOLORCHANGE' -> 16r15.
			'WM_SYSCOMMAND' -> 16r112.
			'WM_SYSDEADCHAR' -> 16r107.
			'WM_SYSKEYDOWN' -> 16r104.
			'WM_SYSKEYUP' -> 16r105.
			'WM_THEMECHANGED' -> 16r31A.
			'WM_TIMECHANGE' -> 16r1E.
			'WM_TIMER' -> 16r113.
			'WM_UNDO' -> 16r304.
			'WM_UPDATEUISTATE' -> 16r128.
			'WM_USER' -> 16r400.
			'WM_USER_LAST' -> 16r7FFF.
			'WM_USERCHANGED' -> 16r54.
			'WM_VKEYTOITEM' -> 16r2E.
			'WM_VSCROLL' -> 16r115.
			'WM_VSCROLLCLIPBOARD' -> 16r30A.
			'WM_WINDOWPOSCHANGED' -> 16r47.
			'WM_WINDOWPOSCHANGING' -> 16r46.
			'WM_XBUTTONDBLCLK' -> 16r20D.
			'WM_XBUTTONDOWN' -> 16r20B.
			'WM_XBUTTONUP' -> 16r20C.
			'WS_BORDER' -> 16r800000.
			'WS_CAPTION' -> 16rC00000.
			'WS_CHILD' -> 16r40000000.
			'WS_CHILDWINDOW' -> 16r40000000.
			'WS_CLIPCHILDREN' -> 16r2000000.
			'WS_CLIPSIBLINGS' -> 16r4000000.
			'WS_DISABLED' -> 16r8000000.
			'WS_DLGFRAME' -> 16r400000.
			'WS_EX_ACCEPTFILES' -> 16r10.
			'WS_EX_APPWINDOW' -> 16r40000.
			'WS_EX_CLIENTEDGE' -> 16r200.
			'WS_EX_COMPOSITED' -> 16r2000000.
			'WS_EX_CONTEXTHELP' -> 16r400.
			'WS_EX_CONTROLPARENT' -> 16r10000.
			'WS_EX_DLGMODALFRAME' -> 16r1.
			'WS_EX_LAYERED' -> 16r80000.
			'WS_EX_LEFT' -> 16r0.
			'WS_EX_LEFTSCROLLBAR' -> 16r4000.
			'WS_EX_LTRREADING' -> 16r0.
			'WS_EX_NOACTIVATE' -> 16r8000000.
			'WS_EX_NOPARENTNOTIFY' -> 16r4.
			'WS_EX_NOTIFYDRAG' -> 16r2.
			'WS_EX_OVERLAPPEDWINDOW' -> 16r300.
			'WS_EX_PALETTEWINDOW' -> 16r188.
			'WS_EX_RIGHT' -> 16r1000.
			'WS_EX_RIGHTSCROLLBAR' -> 16r0.
			'WS_EX_RTLREADING' -> 16r2000.
			'WS_EX_STATICEDGE' -> 16r20000.
			'WS_EX_TOOLWINDOW' -> 16r80.
			'WS_EX_TOPMOST' -> 16r8.
			'WS_EX_TRANSPARENT' -> 16r20.
			'WS_EX_WINDOWEDGE' -> 16r100.
			'WS_GROUP' -> 16r20000.
			'WS_HSCROLL' -> 16r100000.
			'WS_ICONIC' -> 16r20000000.
			'WS_MAXIMIZE' -> 16r1000000.
			'WS_MAXIMIZEBOX' -> 16r10000.
			'WS_MINIMIZE' -> 16r20000000.
			'WS_MINIMIZEBOX' -> 16r20000.
			'WS_OVERLAPPED' -> 16r0.
			'WS_OVERLAPPEDWINDOW' -> 16rCF0000.
			'WS_POPUP' -> 16r80000000.
			'WS_POPUPWINDOW' -> -16r7F780000.
			'WS_SIZEBOX' -> 16r40000.
			'WS_SYSMENU' -> 16r80000.
			'WS_TABSTOP' -> 16r10000.
			'WS_THICKFRAME' -> 16r40000.
			'WS_TILED' -> 16r0.
			'WS_TILEDWINDOW' -> 16rCF0000.
			'WS_VISIBLE' -> 16r10000000.
			'WS_VSCROLL' -> 16r200000
		}!

OS.UserLibrary guid: (Core.GUID fromString: '{64674046-3a82-101b-8181-00aa003743d3}')!

OS.UserLibrary comment: '`UserLibrary` is the `DynamicLinkLibrary` class to represent the Windows system DLL, User32.DLL.

The default instance of this class (which is stored in the OS.User32 global) provides access to most of the Win32 window management API. New functions may be added as required, but the external function naming convention should be followed.

All functions in this library use the stdcall calling convention.'!

!OS.UserLibrary categoriesForClass!External-Libraries-Win32! !

!OS.UserLibrary methodsFor!

blockInput: aBoolean
	"Blocks keyboard and mouse input events from reaching applications. 
		BOOL BlockInput(
			BOOL fBlockIt 	
		);"

	<stdcall: bool BlockInput bool>
	^self invalidCall: _failureCode!

createDialogParam: hInstance lpTemplate: template hWndParent: hParent lpDialogFunc: dlgProc dwInitParam: lParam
	"Create a modeless dialog box from a dialog box template resource. 
		HWND CreateDialog(
  			HINSTANCE hInstance,		// handle of module containing template
			LPCWSTR lpTemplate,			// resource identifier
			HWND hWndParent,			// handle of owner window
			DLGPROC lpDialogFunc, 		// address of dialog proc
			LPARAM dwInitParam 		// value passed to wmInitDialog:
		);"

	<stdcall: handle CreateDialogParamW handle lpvoid handle lpvoid int32>
	^self invalidCall: _failureCode!

defDlgProc: hWnd msg: msg wParam: wParam lParam: lParam
	"Call the default dialog procedure to provide default processing for 
	any window messages that an application does not process. 

		LRESULT DefDlgProc(
			HWND hDlg,	// handle to dialog box
			UINT Msg,	// message
			WPARAM wParam,	// first message parameter
			LPARAM lParam 	// second message parameter
		);"

	<stdcall: uintptr DefDlgProcW handle uint32 uintptr uintptr>
	^self invalidCall: _failureCode!

defWindowProc: hWnd msg: msg wParam: wParam lParam: lParam
	"Call the default window procedure to provide default processing for 
	any window messages that an application does not process. 
	
		LRESULT DefWindowProc(
			HWND hWnd,	// handle to window
			UINT Msg,	// message identifier
			WPARAM wParam,	// first message parameter
			LPARAM lParam 	// second message parameter
		);"

	<stdcall: uintptr DefWindowProcW handle uint32 uintptr uintptr>
	^self invalidCall: _failureCode!

destroyWindow: aWindowHandle
	"Destroys the specified window. WM_DESTROY and WM_NCDESTROY messages are sent
	to the window to deactivate it, and remove the keyboard focus. The window's menu
	is destroyed, the owning threads message queue flushed, outstanding timers are 
	destroyed, clipboard ownership is revoked, the clipboard viewer chain is broken 
	(if the window is at the top of the viewer chain). All owned and child windows
	are also destroyed. Can also be used to destroys modeless dialog boxes created 
	by the CreateDialog function. 
		BOOL DestroyWindow(
			HWND  hWnd 	// handle of window to destroy  
		);"

	<stdcall: bool DestroyWindow handle>
	^self invalidCall: _failureCode!

dispatchMessage: aMSG
	"Dispatch a message to a window procedure.
		LONG DispatchMessage(
  			CONST MSG *lpmsg 	// pointer to structure with message
		);"

	<stdcall: int32 DispatchMessageW MSG*>
	^self invalidCall: _failureCode!

enableWindow: aWindowHandle bEnable: aBoolean
	"Enable or disable mouse and keyboard input to the specified window.
		BOOL EnableWindow(
			HWND hWnd,	// handle to window
			BOOL bEnable 	// flag for enabling or disabling input
		);"

	<stdcall: bool EnableWindow handle bool>
	^self invalidCall: _failureCode!

getActiveWindow
	"Answer the handle of Dolphin's active window (nil if none active)."

	<stdcall: handle GetActiveWindow>
	^self invalidCall: _failureCode!

getAsyncKeyState: virtualKeyCodeInteger
	<stdcall: int16 GetAsyncKeyState int32>
	^self invalidCall: _failureCode!

getDesktopWindow
	"Answer the handle of the desktop (ultimate parent) window. Answer that handle. 
	N.B. Although the desktop window is logically the parent
	of all top-level windows, its handle is not, sadly, that answered by GetParent()
	for such windows. View>>parentView does, however, return the desktop window as the
	parent of top level windows."

	<stdcall: handle GetDesktopWindow>
	^self invalidCall: _failureCode!

getDlgItem: aWindowHandle nIDDlgItem: anIntegerId
	"Retrieves the handle of a control in a dialog box. 
  
		HWND GetDlgItem(
  			HWND  hDlg,		// handle of dialog box
			int  nIDDlgItem 	// identifier of control
		);"

	<stdcall: handle GetDlgItem handle int32>
	^self invalidCall: _failureCode!

getKeyboardLayout: anInteger
	<stdcall: handle GetKeyboardLayout int32>
	^self invalidCall: _failureCode!

getKeyboardLayoutName: pwszKLID
	<stdcall: bool GetKeyboardLayoutNameW lpwstr>
	^self invalidCall: _failureCode!

getKeyboardState: a256ByteArray
	"Copies the status of the 256 virtual keys to the specified buffer. 
		BOOL GetKeyboardState(
			PBYTE lpKeyState 	// address of array to receive status data
		);"

	<stdcall: bool GetKeyboardState lpvoid>
	^self invalidCall: _failureCode!

getKeyNameText: lParam lpString: aString nSize: anInteger
	"Populate a string with the name of a virtual key code
		int GetKeyNameText( 
			LONG lParam,	// second parameter of keyboard message	
			LPWSTR lpString,	// address of buffer for key name	
			int nSize 	// maximum length of key-name string length	
		);"

	<stdcall: int32 GetKeyNameTextW uint32 lpwstr int32>
	^self invalidCall: _failureCode!

getKeyState: virtualKeyCodeInteger
	"Answer the status of the virtual key, virtualKeyCodeInteger. See the Keyboard class.

		SHORT GetKeyState(int  nVirtKey);"

	<stdcall: int16 GetKeyState int32>
	^self invalidCall: _failureCode!

getMessage: aMSG hWnd: aWindowHandle wMsgFilterMin: anIntFilterMin wMsgFilterMax: anIntFilterMax
	"Retrieves the next message from the Win32 input queue in the range integerFilterMin
	integerFilterMax, for the window with handle aWindowHandle (if Null then for all windows)
	into the Win32 MSG structure, aMSG.

	BOOL GetMessage(
		LPMSG  lpMsg,	// address of structure with message
		HWND  hWnd,	// handle of window
		UINT  wMsgFilterMin,	// first message
		UINT  wMsgFilterMax 	// last message
	);	

	Answers 1 if a message was retrieved, 0 if WM_QUIT was retrieved, or -1 if some
	error occurred. N.B. Though Win32 declares GetMessage() as returning a BOOL,
	it doesn't really (because of the error return value) so to avoid errors, as
	suggested in the help), we have it return a signed integer)"

	<stdcall: int32 GetMessageW MSG* handle uint32 uint32>
	^self invalidCall: _failureCode!

getParent: hWnd
	"Answer the handle of the parent window of the specified window. Note that if the window is a top level window (whose parent is really the Desktop window) then the function answers the handle of the owner. For a typical ShellView this will mean the result is 0.  To retrieve the actual parent, use #getAncestor:gaFlags:"

	<stdcall: uint32 GetParent handle>
	^self invalidCall: _failureCode!

getQueueStatus: integerFlags
	"Answer a 32-bit set of flags which indicates the type of messages currently present in
	the in the calling thread's message queue. 
		DWORD GetQueueStatus(
			UINT  flags 	// queue-status flags
		);
	See MSDN for further details."

	<stdcall: uint32 GetQueueStatus uint32>
	^self invalidCall: _failureCode!

getSysColor: index
	"Answer the current color of the specified display element. Display elements are 
	the parts of a window and the Windows display that appear on the system display screen
	(configurable from DisplayProperties/Appearance)
		DWORD GetSysColor(
			int nIndex 	// display element
		);"

	<stdcall: uint32 GetSysColor int32>
	^self invalidCall: _failureCode!

getSysColorBrush: anInteger
	"Answer the handle of one of the standard system colour brushes
		HBRUSH GetSysColorBrush(
  			int index
		);"

	<stdcall: handle GetSysColorBrush int32>
	^self invalidCall: _failureCode!

getSystemMetrics: index
	"Answer the dimension of some display elememnt (in pels) or system configuration setting.
		int GetSystemMetrics(
			int nIndex 	// system metric or configuration setting to retrieve  
		);"

	<stdcall: int32 GetSystemMetrics int32>
	^self invalidCall: _failureCode!

inSendMessage
	<stdcall: bool InSendMessage>
	^self invalidCall: _failureCode!

isWindow: hWnd
	"Answer whether the window handle, hWnd, is currently valid"

	<stdcall: bool IsWindow handle>
	^self invalidCall: _failureCode!

isWindowEnabled: hWnd
	"Answer whether the window with handle, hWnd, is currently enabled (i.e.
	prepared to accept user input"

	<stdcall: bool IsWindowEnabled handle>
	^self invalidCall: _failureCode!

isWindowVisible: hWnd
	"Answer whether the window with handle, hWnd, is currently visible (i.e. not hidden)."

	<stdcall: bool IsWindowVisible handle>
	^self invalidCall: _failureCode!

killTimer: aWindowHandle uIDEvent: anInteger
	"Destroy the specified timer. Any pending wmTimer: messages for the receiver
	are also removed.
		BOOL KillTimer(
			HWND hWnd,	// handle of window that installed timer
			UINT uIDEvent 	// timer identifier
		);"

	<stdcall: bool KillTimer handle uint32>
	^self invalidCall: _failureCode!

loadCursor: anInstanceHandle lpCursorName: anIntegerID
	"Loads the specified cursor resource from the module with the specified handle
	Under Win32 it is not necessary to destroy cursors loaded in this manner.

		HCURSOR LoadCursor(
  			HINSTANCE  hInstance,	// handle of application instance
			LPCWSTR  lpCursorName 	// name string or cursor resource identifier  
		);"

	<stdcall: handle LoadCursorW handle lpvoid>
	^self invalidCall: _failureCode!

loadKeyboardLayout: pwszKLID flags: flags
	<stdcall: handle LoadKeyboardLayoutW lpwstr uint32>
	^self invalidCall: _failureCode!

loadString: anExternalHandle uID: anIntegerID lpBuffer: aString nBufferMax: anIntegerLength
	"Load a string resource from the executable file associated with 
	the specified module, into the specified buffer appending
	a terminating null character. Answer the length of the string, or 0 
	if it does not exist.
		int LoadString(
			HINSTANCE hInstance,	// handle of module containing string resource 
			UINT uID,				// resource identifier 
			LPTSTR lpBuffer,		// address of buffer for resource 
			int nBufferMax 		// size of buffer
		);"

	<stdcall: int32 LoadStringW handle uint32 lpvoid int32>
	^self invalidCall: _failureCode!

mapVirtualKey: keyCode uMapType: mapType
	"Map a virtual-key code into a scan code or character value, or translate a scan code into a virtual-key code. 

	The Meaning of keycode and the result of the translation depends on the maptype:

		keyCode					Answer
	0	virtual key code		->	scan code
	1	scan code				->	virtual key code
	2	virtual key code		->	character value
	3	scan code				->	virtual key code	

		UINT	MapVirtualKey(
			UINT uCode,
			UINT uMapType);"

	<stdcall: uint32 MapVirtualKeyW uint32 uint32>
	^self invalidCall: _failureCode!

messageBeep: anInteger
	"Plays a waveform identified by the argument, anInteger, in the registry.
			BOOL MessageBeep(
			UINT uType 	// sound type  
			);"

	<stdcall: bool MessageBeep uint32>
	^self invalidCall: _failureCode!

messageBox: anExternalHandle text: textString caption: captionString style: styleInteger icon: iconIdentifier instance: hInstance
	| iconId struct wasDisabled hWnd response isTaskModal dwStyle |
	isTaskModal := styleInteger allMask: MB_TASKMODAL.
	hWnd := isTaskModal
				ifTrue: [0]
				ifFalse: 
					["#2107: getActiveWindow may return nil, e.g. in a headless app with no windows"
					anExternalHandle ifNil: [User32 getActiveWindow ?? 0]].
	struct := MSGBOXPARAMSW new.
	dwStyle := styleInteger.
	struct text: textString.
	struct caption: captionString.
	iconId := iconIdentifier.
	iconId isNil
		ifFalse: 
			[iconId := iconId asResourceId.
			struct lpszIcon: iconId asUIntPtr.
			hInstance notNil ifTrue: [struct hInstance: hInstance asParameter]].
	struct dwStyle: dwStyle.
	struct hwndOwner: hWnd.
	isTaskModal
		ifTrue: 
			["If taskModal, then the owner will be the desktop so we need to get actual active view"
			hWnd := self getActiveWindow.
			"Ensure owner is (temporarily) enabled to prevent losing activation when box is closed"
			(wasDisabled := (self isWindowEnabled: hWnd) not) ifTrue: [self enableWindow: hWnd bEnable: true].
			response := 
					[SessionManager.Current inputState startIdleTimer.
					"Task modal only disables windows in the calling thread, so we can't use an
					overlapped call here."
					self messageBoxIndirect: struct]
							ensure: [SessionManager.Current inputState stopIdleTimer]]
		ifFalse: 
			[wasDisabled := (self isWindowEnabled: hWnd) not.
			"MessageBoxIndirect is called using an overlapped call on a separate thread to avoid
			losing control of the message loop. If the initiating process is the UI process then its
			priority is boosted so that the operation requested by the user completes more quickly 
			when the dialog is closed."
			Processor forkMainIfMain
				ifTrue: 
					[| proc |
					proc := Processor activeProcess.
					proc priority: proc priority + 1].
			response := self overlappedMsgBoxIndirect: struct].

	"The message box will unhelpfully re-enable the window regardless of whether previously disabled"
	wasDisabled ifTrue: [self enableWindow: hWnd bEnable: false].
	response == 0 ifTrue: [self systemError].
	^response!

messageBoxIndirect: aMSGBOXPARAMS
	"Open a message box with the details specified in the structure.

		int MessageBox(
			LPMSGBOXPARRAMS lpMsgBoxParams;
		);"

	<stdcall: int32 MessageBoxIndirectW MSGBOXPARAMSW*>
	^self invalidCall: _failureCode!

msgWaitForMultipleObjectsEx: countInteger pHandles: handles dwMilliseconds: millisecsInteger dwWakeMask: maskInteger dwFlags: aBoolean
	"Waits until when one of the following occurs: 
		·	either any one of, or all of (the number of handles being specified 
			by the argument, countInteger, and whether to wait for a single object
			or all of the objects being specified by the argument, waitBoolean), 
			the objects whose handles are specified by the argument, handles 
			(which may be a single handle, or a UInt32Array) are 
			in the signaled state; or
		·	A Win32 message of a type which matches the type mask specified by
			the argument, maskInteger, becomes available in the message queue (
			uses the same flags as #getQueueStatus:); or
		·	the number of milliseconds specified by the argument, millisecsInteger,
			elapses.

	MsgWaitForMultipleObjects should only be called when there are no further messages
	waiting in the input queue, because it only detects the arrival of new messages (this is fixed
	in Win98 and NT5 with the addition of the MWMO_INPUTAVAILABLE flag).

	N.B. Under NT, the handles in the argument, handles, must have SYNCHRONIZE access.

	If successful, answer the event that cause the function to return. See Win32 documentation
	for specific return values. If the function fails, answers -1. KernelLibrary>>getLastError
	can be used to get extended error information

		DWORD MsgWaitForMultipleObjectsEx(
			DWORD nCount,
			LPHANDLE pHandles,
			DWORD dwMilliseconds,
			DWORD dwWakeMask,
			DWORD dwFlags)
	"

	<stdcall: int32 MsgWaitForMultipleObjectsEx uint32 lpvoid uint32 uint32 uint32>
	^self invalidCall: _failureCode!

overlappedMsgBoxIndirect: aMSGBOXPARAMS
	"Private - Open a message box with the details specified in the structure
	as an overlapped call (i.e. on a separate thread).
	N.B. Don't use for MB_TASKMODAL message boxes.

		int MessageBox(
			LPMSGBOXPARRAMS lpMsgBoxParams;
		);"

	<overlap stdcall: int32 MessageBoxIndirectW MSGBOXPARAMSW*>
	^self invalidCall: _failureCode!

peekMessage: aMSG hWnd: aWindowHandle uMsgFilterMin: anIntFilterMin uMsgFilterMax: uMsgFilterMax wRemoveMsg: anIntFlags
	"Check the threads message queue for messages for the Window with
	handle aWindowHandle (all windows if nil/0, app messages if -1) in the range
	anIntFilterMin..anIntFilterMax (all messages if 0..0), retrieving 
	the first (if any) of such messages into aMSG, answering whether 
	a message was found. The message is optionally removed from the 
	queue depending on the value of the argument, anIntFlags (PM_REMOVE/
	PM_NOREMOVE). The flag value PmNoYield is obsolete, and has no effect
	in Win32.

		BOOL PeekMessage(
			LPMSG  lpMsg,			// address of structure for message
			HWND  hWnd,			// handle of window
			UINT  uMsgFilterMin,	// first message
			UINT  uMsgFilterMax,	// last message
			UINT  wRemoveMsg 		// removal flags
		);"

	<stdcall: bool PeekMessageW MSG* handle uint32 uint32 uint32>
	^self invalidCall: _failureCode!

postMessage: aWindowHandle msg: msg wParam: wParam lParam: lParam
	"Post a message to aWindowHandle.

	LRESULT PostMessage(
		HWND hWnd, 		// handle of destination window
		UINT Msg, 		// message to send
		WPARAM wParam, 	// first message parameter
		LPARAM lParam 		// second message parameter
	   );"

	<stdcall: intptr PostMessageW handle uint32 uintptr intptr>
	^self invalidCall: _failureCode!

postQuitMessage: anInteger
	"Post a WM_QUIT message to the current thread, initiating system shutdown.
		VOID PostQuitMessage(
			int  nExitCode 	// exit code
		);"

	<stdcall: void PostQuitMessage int32>
	^self invalidCall: _failureCode!

postThreadMessage: anIntegerId msg: msg wParam: wParam lParam: lParam
	"Post a message to the message queue of the specified thread for asynchronous processing.
		BOOL PostThreadMessage(
  			DWORD  idThread,	// thread identifier
			UINT  Msg,		// message to post
			WPARAM  wParam,	// first message parameter
			LPARAM  lParam 	// second message parameter);"

	<stdcall: bool PostThreadMessageW handle uint32 uintptr uintptr>
	^self invalidCall: _failureCode!

sendMessage: aWindowHandle msg: msg wParam: wParam lParam: lParam
	"The SendMessage function sends the specified message to a window or windows.
	The function calls the window procedure for the specified window and does not
	return until the window procedure has processed the message. The PostMessage
	function, in contrast, posts a message to a thread's message queue and returns
	immediately. 

	Implementation Note: Although LPARAM is defined as a signed parameter, more often
	than not it is used to pass an unsigned 32-bit value. As we have a strict definition
	of what can be passed to a signed integer parameter (i.e. only valid two's complement 
	values that fit within the required size), we used the slightly more relaxed unsigned 
	specification. This allows LargeIntegers > the maximum positive signed value for
	the machine word size to be passed.

	LRESULT SendMessage(
		HWND hWnd, 		// handle of destination window
		UINT Msg, 		// message to send
		WPARAM wParam, 	// first message parameter
		LPARAM lParam 		// second message parameter
	   );"

	<stdcall: intptr SendMessageW handle uint32 uintptr uintptr>
	^self invalidCall: _failureCode!

setActiveWindow: aHandle
	"Makes the specified top-level window associated with the current thread the active window. 
		HWND SetActiveWindow( HWND hWnd);"

	<stdcall: handle SetActiveWindow handle>
	^self invalidCall: _failureCode!

setCursor: aWindowHandle
	"Set the current system cursor to the argument. N.B. This has only a temporary effect, as the system will
	change the cursor whenever it moves over a window which either has a class Cursor set, or responds to the
	the WM_SETCURSOR message. See the Cursor class.

		HCURSOR SetCursor(
  			HCURSOR  hCursor 	// handle of cursor
		);"

	<stdcall: handle SetCursor handle>
	^self invalidCall: _failureCode!

setDlgItemText: aWindowHandle nIDDlgItem: anIntegerId lpString: aString
	"Sets the title or text of a control in a dialog box. 
		BOOL SetDlgItemText(
  			HWND  hDlg,		// handle of dialog box
			int  nIDDlgItem,	// identifier of control
			LPCWSTR  lpString 	// text to set
			);"

	<stdcall: bool SetDlgItemTextW handle int32 lpwstr>
	^self invalidCall: _failureCode!

setKeyboardState: a256ByteArray
	"Copy the specified 256-byte array of keyboard key states into the 
	keyboard-input state table (also accessed by the GetKeyboardState and 
	GetKeyState functions). Changes made to the table affect only the calling
	thread.
		BOOL SetKeyboardState(
  			LPBYTE lpKeyState 	// address of array with virtual-key codes
		   );"

	<stdcall: bool SetKeyboardState lpvoid>
	^self invalidCall: _failureCode!

setTimer: aWindowHandle nIDEvent: anIntegerId uElapse: anInteger lpTimerFunc: callbackProc
	"Create a timer with the specified time-out value.
	N.B. The preferred method of performing time triggered activities in Dolphin is to make
	use of Delays in conjunction with Processes. These are more portable, powerful, flexible, 
	and have a higher resolution capability.
		UINT SetTimer(
			HWND hWnd,	// handle of window for timer messages
			UINT nIDEvent,	// timer identifier
			UINT uElapse,	// time-out value
			TIMERPROC lpTimerFunc 	// address of timer procedure
		);"

	<stdcall: uint32 SetTimer handle uint32 uint32 lpvoid>
	^self invalidCall: _failureCode!

setWindowText: aWindowHandle lpString: aString
	"Set the 'text' of the specified window.
		BOOL SetWindowText(
			HWND hWnd,		// handle of window or control
			LPCWSTR lpString 	// address of string
		);"

	"Note that we can always pass a UTF16 string - Windows will translate automatically for non-Unicode windows."

	<stdcall: bool SetWindowTextW handle lpwstr>
	^self invalidCall: _failureCode!

showWindow: aWindowHandle nCmdShow: flags
	"Set the specified window's show state. 
		BOOL ShowWindow(
			HWND hWnd,	// handle of window
			int nCmdShow 	// show state of window
		);"

	<stdcall: bool ShowWindow handle int32>
	^self invalidCall: _failureCode!

translateMessage: aMSG
	"Translates virtual-key messages into character messages, posting them to the message queue to
	be read by subsequent calls to #getMessage:etc or #peekMessage:etc.

		BOOL TranslateMessage(
			CONST MSG *lpMsg 	// address of structure with message
		);"

	<stdcall: bool TranslateMessage MSG*>
	^self invalidCall: _failureCode!

updateWindow: hWnd
	"Repaint the client area of the specified window by sending a wmPaint: directly to
	the window if its update region is not empty.
		BOOL UpdateWindow(
			HWND hWnd 	// handle of window  
		);"

	<stdcall: bool UpdateWindow handle>
	^self invalidCall: _failureCode!

vkKeyScan: aChar
	"Translate a character to the corresponding virtual-key code 
	and shift state for the current keyboard.
		SHORT VkKeyScan(
			WCHAR ch 	// character to translate
	   );"

	<stdcall: int16 VkKeyScanW char>
	^self invalidCall: _failureCode! !

!OS.UserLibrary categoriesForMethods!
blockInput:!public!win32 functions-window! !
createDialogParam:lpTemplate:hWndParent:lpDialogFunc:dwInitParam:!public!win32 functions-dialog box! !
defDlgProc:msg:wParam:lParam:!public!win32 functions-window procedure! !
defWindowProc:msg:wParam:lParam:!public!win32 functions-window procedure! !
destroyWindow:!public!win32 functions-window! !
dispatchMessage:!public!win32 functions-message and message queue! !
enableWindow:bEnable:!public!win32 functions-keyboard input! !
getActiveWindow!public!win32 functions-keyboard input! !
getAsyncKeyState:!public!win32 functions-keyboard input! !
getDesktopWindow!public!win32 functions-window! !
getDlgItem:nIDDlgItem:!public!win32 functions-dialog box! !
getKeyboardLayout:!public!win32 functions-keyboard input! !
getKeyboardLayoutName:!public!win32 functions-keyboard input! !
getKeyboardState:!public!win32 functions-keyboard input! !
getKeyNameText:lpString:nSize:!public!win32 functions-keyboard input! !
getKeyState:!public!win32 functions-keyboard input! !
getMessage:hWnd:wMsgFilterMin:wMsgFilterMax:!public!win32 functions-message and message queue! !
getParent:!public!win32 functions-window! !
getQueueStatus:!public!win32 functions-message and message queue! !
getSysColor:!public!win32 functions-system information! !
getSysColorBrush:!public!win32 functions-cursor! !
getSystemMetrics:!public!win32 functions-system information! !
inSendMessage!public!win32 functions-message and message queue! !
isWindow:!public!win32 functions-window! !
isWindowEnabled:!public!win32 functions-window! !
isWindowVisible:!public!win32 functions-window! !
killTimer:uIDEvent:!public!win32 functions-timer! !
loadCursor:lpCursorName:!public!win32 functions-cursor! !
loadKeyboardLayout:flags:!public!win32 functions-keyboard input! !
loadString:uID:lpBuffer:nBufferMax:!public!win32 functions-string manipulation! !
mapVirtualKey:uMapType:!public!win32 functions-keyboard input! !
messageBeep:!public!win32 functions-error! !
messageBox:text:caption:style:icon:instance:!displaying!private! !
messageBoxIndirect:!public!win32 functions-dialog box! !
msgWaitForMultipleObjectsEx:pHandles:dwMilliseconds:dwWakeMask:dwFlags:!public!win32 functions-synchronization! !
overlappedMsgBoxIndirect:!private!win32 functions-dialog box! !
peekMessage:hWnd:uMsgFilterMin:uMsgFilterMax:wRemoveMsg:!public!win32 functions-message and message queue! !
postMessage:msg:wParam:lParam:!public!win32 functions-message and message queue! !
postQuitMessage:!public!win32 functions-message and message queue! !
postThreadMessage:msg:wParam:lParam:!public!win32 functions-message and message queue! !
sendMessage:msg:wParam:lParam:!public!win32 functions-message and message queue! !
setActiveWindow:!public!win32 functions-keyboard input! !
setCursor:!public!win32 functions-cursor! !
setDlgItemText:nIDDlgItem:lpString:!public!win32 functions-dialog box! !
setKeyboardState:!public!win32 functions-keyboard input! !
setTimer:nIDEvent:uElapse:lpTimerFunc:!public!win32 functions-timer! !
setWindowText:lpString:!public!win32 functions-window! !
showWindow:nCmdShow:!public!win32 functions-window! !
translateMessage:!public!win32 functions-message and message queue! !
updateWindow:!public!win32 functions-painting and drawing! !
vkKeyScan:!public!win32 functions-keyboard input! !
!

!OS.UserLibrary class methodsFor!

clear
	"Private - Clear down cached external function addresses and any default 
	instances of the receiver from previous runs. etc."

	super clear.
	#(#{OS.SystemMetrics} #{UI.DisplayMonitor}) do: [:each | each ifDefined: [:c | c reset]]!

fileName
	"Answer the host system file name of the external library which 
	the receiver represents."

	^'USER32'!

initialize
	DesiredDpiAwarenessContext := DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2!

sharedVariableName
	^#{OS.User32}! !

!OS.UserLibrary class categoriesForMethods!
clear!initializing!private! !
fileName!constants!public! !
initialize!class initialization!public! !
sharedVariableName!constants!private! !
!

