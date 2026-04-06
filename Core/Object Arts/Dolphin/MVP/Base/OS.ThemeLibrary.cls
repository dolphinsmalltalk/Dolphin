"Filed out from Dolphin Smalltalk"!

External.WindowsSystemLibrary
	subclass: #'OS.ThemeLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'ABS_DOWNDISABLED' -> 16r8.
			'ABS_DOWNHOT' -> 16r6.
			'ABS_DOWNNORMAL' -> 16r5.
			'ABS_DOWNPRESSED' -> 16r7.
			'ABS_LEFTDISABLED' -> 16rC.
			'ABS_LEFTHOT' -> 16rA.
			'ABS_LEFTNORMAL' -> 16r9.
			'ABS_LEFTPRESSED' -> 16rB.
			'ABS_RIGHTDISABLED' -> 16r10.
			'ABS_RIGHTHOT' -> 16rE.
			'ABS_RIGHTNORMAL' -> 16rD.
			'ABS_RIGHTPRESSED' -> 16rF.
			'ABS_UPDISABLED' -> 16r4.
			'ABS_UPHOT' -> 16r2.
			'ABS_UPNORMAL' -> 16r1.
			'ABS_UPPRESSED' -> 16r3.
			'BP_CHECKBOX' -> 16r3.
			'BP_GROUPBOX' -> 16r4.
			'BP_PUSHBUTTON' -> 16r1.
			'BP_RADIOBUTTON' -> 16r2.
			'BP_USERBUTTON' -> 16r5.
			'BPBF_COMPATIBLEBITMAP' -> 16r0.
			'BPBF_DIB' -> 16r1.
			'BPBF_TOPDOWNDIB' -> 16r2.
			'BPBF_TOPDOWNMONODIB' -> 16r3.
			'BPPF_ERASE' -> 16r1.
			'BPPF_NOCLIP' -> 16r2.
			'BPPF_NONCLIENT' -> 16r4.
			'BT_BORDERFILL' -> 16r1.
			'BT_ELLIPSE' -> 16r2.
			'BT_IMAGEFILE' -> 16r0.
			'BT_NONE' -> 16r2.
			'BT_RECT' -> 16r0.
			'BT_ROUNDRECT' -> 16r1.
			'CA_CENTER' -> 16r1.
			'CA_LEFT' -> 16r0.
			'CA_RIGHT' -> 16r2.
			'CBS_CHECKEDDISABLED' -> 16r8.
			'CBS_CHECKEDHOT' -> 16r6.
			'CBS_CHECKEDNORMAL' -> 16r5.
			'CBS_CHECKEDPRESSED' -> 16r7.
			'CBS_DISABLED' -> 16r4.
			'CBS_HOT' -> 16r2.
			'CBS_MIXEDDISABLED' -> 16rC.
			'CBS_MIXEDHOT' -> 16rA.
			'CBS_MIXEDNORMAL' -> 16r9.
			'CBS_MIXEDPRESSED' -> 16rB.
			'CBS_NORMAL' -> 16r1.
			'CBS_PUSHED' -> 16r3.
			'CBS_UNCHECKEDDISABLED' -> 16r4.
			'CBS_UNCHECKEDHOT' -> 16r2.
			'CBS_UNCHECKEDNORMAL' -> 16r1.
			'CBS_UNCHECKEDPRESSED' -> 16r3.
			'CBXS_DISABLED' -> 16r4.
			'CBXS_HOT' -> 16r2.
			'CBXS_NORMAL' -> 16r1.
			'CBXS_PRESSED' -> 16r3.
			'CHEVS_HOT' -> 16r2.
			'CHEVS_NORMAL' -> 16r1.
			'CHEVS_PRESSED' -> 16r3.
			'CLP_TIME' -> 16r1.
			'CLS_NORMAL' -> 16r1.
			'CP_DROPDOWNBUTTON' -> 16r1.
			'CS_ACTIVE' -> 16r1.
			'CS_DISABLED' -> 16r3.
			'CS_INACTIVE' -> 16r2.
			'DNHZS_DISABLED' -> 16r4.
			'DNHZS_HOT' -> 16r2.
			'DNHZS_NORMAL' -> 16r1.
			'DNHZS_PRESSED' -> 16r3.
			'DNS_DISABLED' -> 16r4.
			'DNS_HOT' -> 16r2.
			'DNS_NORMAL' -> 16r1.
			'DNS_PRESSED' -> 16r3.
			'DTBG_CLIPRECT' -> 16r1.
			'DTBG_COMPUTINGREGION' -> 16r10.
			'DTBG_DRAWSOLID' -> 16r2.
			'DTBG_MIRRORDC' -> 16r20.
			'DTBG_OMITBORDER' -> 16r4.
			'DTBG_OMITCONTENT' -> 16r8.
			'DTT_GRAYED' -> 16r1.
			'EBHC_HOT' -> 16r2.
			'EBHC_NORMAL' -> 16r1.
			'EBHC_PRESSED' -> 16r3.
			'EBHP_HOT' -> 16r2.
			'EBHP_NORMAL' -> 16r1.
			'EBHP_PRESSED' -> 16r3.
			'EBHP_SELECTEDHOT' -> 16r5.
			'EBHP_SELECTEDNORMAL' -> 16r4.
			'EBHP_SELECTEDPRESSED' -> 16r6.
			'EBM_HOT' -> 16r2.
			'EBM_NORMAL' -> 16r1.
			'EBM_PRESSED' -> 16r3.
			'EBNGC_HOT' -> 16r2.
			'EBNGC_NORMAL' -> 16r1.
			'EBNGC_PRESSED' -> 16r3.
			'EBNGE_HOT' -> 16r2.
			'EBNGE_NORMAL' -> 16r1.
			'EBNGE_PRESSED' -> 16r3.
			'EBP_HEADERBACKGROUND' -> 16r1.
			'EBP_HEADERCLOSE' -> 16r2.
			'EBP_HEADERPIN' -> 16r3.
			'EBP_IEBARMENU' -> 16r4.
			'EBP_NORMALGROUPBACKGROUND' -> 16r5.
			'EBP_NORMALGROUPCOLLAPSE' -> 16r6.
			'EBP_NORMALGROUPEXPAND' -> 16r7.
			'EBP_NORMALGROUPHEAD' -> 16r8.
			'EBP_SPECIALGROUPBACKGROUND' -> 16r9.
			'EBP_SPECIALGROUPCOLLAPSE' -> 16rA.
			'EBP_SPECIALGROUPEXPAND' -> 16rB.
			'EBP_SPECIALGROUPHEAD' -> 16rC.
			'EBSGC_HOT' -> 16r2.
			'EBSGC_NORMAL' -> 16r1.
			'EBSGC_PRESSED' -> 16r3.
			'EBSGE_HOT' -> 16r2.
			'EBSGE_NORMAL' -> 16r1.
			'EBSGE_PRESSED' -> 16r3.
			'EP_CARET' -> 16r2.
			'EP_EDITTEXT' -> 16r1.
			'ETDT_DISABLE' -> 16r1.
			'ETDT_ENABLE' -> 16r2.
			'ETDT_ENABLETAB' -> 16r6.
			'ETDT_USETABTEXTURE' -> 16r4.
			'ETS_ASSIST' -> 16r7.
			'ETS_DISABLED' -> 16r4.
			'ETS_FOCUSED' -> 16r5.
			'ETS_HOT' -> 16r2.
			'ETS_NORMAL' -> 16r1.
			'ETS_READONLY' -> 16r6.
			'ETS_SELECTED' -> 16r3.
			'FS_ACTIVE' -> 16r1.
			'FS_INACTIVE' -> 16r2.
			'FT_HORZGRADIENT' -> 16r2.
			'FT_RADIALGRADIENT' -> 16r3.
			'FT_SOLID' -> 16r0.
			'FT_TILEIMAGE' -> 16r4.
			'FT_VERTGRADIENT' -> 16r1.
			'GBS_DISABLED' -> 16r2.
			'GBS_NORMAL' -> 16r1.
			'GFST_DPI' -> 16r2.
			'GFST_NONE' -> 16r0.
			'GFST_SIZE' -> 16r1.
			'GLPS_CLOSED' -> 16r1.
			'GLPS_OPENED' -> 16r2.
			'GP_BORDER' -> 16r1.
			'GP_LINEHORZ' -> 16r2.
			'GP_LINEVERT' -> 16r3.
			'GT_FONTGLYPH' -> 16r2.
			'GT_IMAGEGLYPH' -> 16r1.
			'GT_NONE' -> 16r0.
			'HA_CENTER' -> 16r1.
			'HA_LEFT' -> 16r0.
			'HA_RIGHT' -> 16r2.
			'HBS_DISABLED' -> 16r4.
			'HBS_HOT' -> 16r2.
			'HBS_NORMAL' -> 16r1.
			'HBS_PUSHED' -> 16r3.
			'HILS_HOT' -> 16r2.
			'HILS_NORMAL' -> 16r1.
			'HILS_PRESSED' -> 16r3.
			'HIRS_HOT' -> 16r2.
			'HIRS_NORMAL' -> 16r1.
			'HIRS_PRESSED' -> 16r3.
			'HIS_HOT' -> 16r2.
			'HIS_NORMAL' -> 16r1.
			'HIS_PRESSED' -> 16r3.
			'HP_HEADERITEM' -> 16r1.
			'HP_HEADERITEMLEFT' -> 16r2.
			'HP_HEADERITEMRIGHT' -> 16r3.
			'HP_HEADERSORTARROW' -> 16r4.
			'HSAS_SORTEDDOWN' -> 16r2.
			'HSAS_SORTEDUP' -> 16r1.
			'HSS_DISABLED' -> 16r4.
			'HSS_HOT' -> 16r2.
			'HSS_NORMAL' -> 16r1.
			'HSS_PUSHED' -> 16r3.
			'HTS_DISABLED' -> 16r4.
			'HTS_HOT' -> 16r2.
			'HTS_NORMAL' -> 16r1.
			'HTS_PUSHED' -> 16r3.
			'HTTB_BACKGROUNDSEG' -> 16r0.
			'HTTB_CAPTION' -> 16r4.
			'HTTB_FIXEDBORDER' -> 16r2.
			'HTTB_RESIZINGBORDER' -> 16rF0.
			'HTTB_RESIZINGBORDER_BOTTOM' -> 16r80.
			'HTTB_RESIZINGBORDER_LEFT' -> 16r10.
			'HTTB_RESIZINGBORDER_RIGHT' -> 16r40.
			'HTTB_RESIZINGBORDER_TOP' -> 16r20.
			'HTTB_SIZINGTEMPLATE' -> 16r100.
			'HTTB_SYSTEMSIZINGMARGINS' -> 16r200.
			'ICE_ALPHA' -> 16r4.
			'ICE_GLOW' -> 16r1.
			'ICE_NONE' -> 16r0.
			'ICE_PULSE' -> 16r3.
			'ICE_SHADOW' -> 16r2.
			'IL_HORIZONTAL' -> 16r1.
			'IL_VERTICAL' -> 16r0.
			'IST_DPI' -> 16r2.
			'IST_NONE' -> 16r0.
			'IST_SIZE' -> 16r1.
			'LIS_DISABLED' -> 16r4.
			'LIS_HOT' -> 16r2.
			'LIS_NORMAL' -> 16r1.
			'LIS_SELECTED' -> 16r3.
			'LIS_SELECTEDNOTFOCUS' -> 16r5.
			'LVEB_HOVER' -> 16r2.
			'LVEB_NORMAL' -> 16r1.
			'LVEB_PUSHED' -> 16r3.
			'LVP_COLLAPSEBUTTON' -> 16r9.
			'LVP_EMPTYTEXT' -> 16r5.
			'LVP_EXPANDBUTTON' -> 16r8.
			'LVP_LISTDETAIL' -> 16r3.
			'LVP_LISTGROUP' -> 16r2.
			'LVP_LISTITEM' -> 16r1.
			'LVP_LISTSORTEDDETAIL' -> 16r4.
			'MAXBS_DISABLED' -> 16r4.
			'MAXBS_HOT' -> 16r2.
			'MAXBS_NORMAL' -> 16r1.
			'MAXBS_PUSHED' -> 16r3.
			'MDP_NEWAPPBUTTON' -> 16r1.
			'MDP_SEPERATOR' -> 16r2.
			'MDS_CHECKED' -> 16r5.
			'MDS_DISABLED' -> 16r4.
			'MDS_HOT' -> 16r2.
			'MDS_HOTCHECKED' -> 16r6.
			'MDS_NORMAL' -> 16r1.
			'MDS_PRESSED' -> 16r3.
			'MENU_BARBACKGROUND' -> 16r7.
			'MENU_BARITEM' -> 16r8.
			'MENU_CHEVRON_TMSCHEMA' -> 16r5.
			'MENU_MENUBARDROPDOWN_TMSCHEMA' -> 16r4.
			'MENU_MENUBARITEM_TMSCHEMA' -> 16r3.
			'MENU_MENUDROPDOWN_TMSCHEMA' -> 16r2.
			'MENU_MENUITEM_TMSCHEMA' -> 16r1.
			'MENU_POPUPBACKGROUND' -> 16r9.
			'MENU_POPUPBORDERS' -> 16rA.
			'MENU_POPUPCHECK' -> 16rB.
			'MENU_POPUPCHECKBACKGROUND' -> 16rC.
			'MENU_POPUPGUTTER' -> 16rD.
			'MENU_POPUPITEM' -> 16rE.
			'MENU_POPUPITEM_FOCUSABLE' -> 16r1B.
			'MENU_POPUPITEMKBFOCUS' -> 16r1A.
			'MENU_POPUPSEPARATOR' -> 16rF.
			'MENU_POPUPSUBMENU' -> 16r10.
			'MENU_POPUPSUBMENU_HCHOT' -> 16r15.
			'MENU_SEPARATOR_TMSCHEMA' -> 16r6.
			'MENU_SYSTEMCLOSE' -> 16r11.
			'MENU_SYSTEMCLOSE_HCHOT' -> 16r16.
			'MENU_SYSTEMMAXIMIZE' -> 16r12.
			'MENU_SYSTEMMAXIMIZE_HCHOT' -> 16r17.
			'MENU_SYSTEMMINIMIZE' -> 16r13.
			'MENU_SYSTEMMINIMIZE_HCHOT' -> 16r18.
			'MENU_SYSTEMRESTORE' -> 16r14.
			'MENU_SYSTEMRESTORE_HCHOT' -> 16r19.
			'MINBS_DISABLED' -> 16r4.
			'MINBS_HOT' -> 16r2.
			'MINBS_NORMAL' -> 16r1.
			'MINBS_PUSHED' -> 16r3.
			'MNCS_ACTIVE' -> 16r1.
			'MNCS_DISABLED' -> 16r3.
			'MNCS_INACTIVE' -> 16r2.
			'MP_CHEVRON' -> 16r5.
			'MP_MENUBARDROPDOWN' -> 16r4.
			'MP_MENUBARITEM' -> 16r3.
			'MP_MENUDROPDOWN' -> 16r2.
			'MP_MENUITEM' -> 16r1.
			'MP_SEPARATOR' -> 16r6.
			'MS_DEMOTED' -> 16r3.
			'MS_NORMAL' -> 16r1.
			'MS_SELECTED' -> 16r2.
			'MXCS_ACTIVE' -> 16r1.
			'MXCS_DISABLED' -> 16r3.
			'MXCS_INACTIVE' -> 16r2.
			'OT_ABOVELASTBUTTON' -> 16rC.
			'OT_BELOWLASTBUTTON' -> 16rD.
			'OT_BOTTOMLEFT' -> 16r3.
			'OT_BOTTOMMIDDLE' -> 16r5.
			'OT_BOTTOMRIGHT' -> 16r4.
			'OT_LEFTOFCAPTION' -> 16r8.
			'OT_LEFTOFLASTBUTTON' -> 16rA.
			'OT_MIDDLELEFT' -> 16r6.
			'OT_MIDDLERIGHT' -> 16r7.
			'OT_RIGHTOFCAPTION' -> 16r9.
			'OT_RIGHTOFLASTBUTTON' -> 16rB.
			'OT_TOPLEFT' -> 16r0.
			'OT_TOPMIDDLE' -> 16r2.
			'OT_TOPRIGHT' -> 16r1.
			'PBS_DEFAULTED' -> 16r5.
			'PBS_DISABLED' -> 16r4.
			'PBS_HOT' -> 16r2.
			'PBS_NORMAL' -> 16r1.
			'PBS_PRESSED' -> 16r3.
			'PGRP_DOWN' -> 16r2.
			'PGRP_DOWNHORZ' -> 16r4.
			'PGRP_UP' -> 16r1.
			'PGRP_UPHORZ' -> 16r3.
			'PO_CLASS' -> 16r2.
			'PO_GLOBAL' -> 16r3.
			'PO_NOTFOUND' -> 16r4.
			'PO_PART' -> 16r1.
			'PO_STATE' -> 16r0.
			'PP_BAR' -> 16r1.
			'PP_BARVERT' -> 16r2.
			'PP_CHUNK' -> 16r3.
			'PP_CHUNKVERT' -> 16r4.
			'RBS_CHECKEDDISABLED' -> 16r8.
			'RBS_CHECKEDHOT' -> 16r6.
			'RBS_CHECKEDNORMAL' -> 16r5.
			'RBS_CHECKEDPRESSED' -> 16r7.
			'RBS_DISABLED' -> 16r4.
			'RBS_HOT' -> 16r2.
			'RBS_NORMAL' -> 16r1.
			'RBS_PUSHED' -> 16r3.
			'RBS_UNCHECKEDDISABLED' -> 16r4.
			'RBS_UNCHECKEDHOT' -> 16r2.
			'RBS_UNCHECKEDNORMAL' -> 16r1.
			'RBS_UNCHECKEDPRESSED' -> 16r3.
			'RP_BACKGROUND' -> 16r7.
			'RP_BAND' -> 16r3.
			'RP_CHEVRON' -> 16r4.
			'RP_CHEVRONVERT' -> 16r5.
			'RP_GRIPPER' -> 16r1.
			'RP_GRIPPERVERT' -> 16r2.
			'RP_SPLITERVERT' -> 16r8.
			'RP_SPLITTER' -> 16r7.
			'SBP_ARROWBTN' -> 16r1.
			'SBP_GRIPPERHORZ' -> 16r8.
			'SBP_GRIPPERVERT' -> 16r9.
			'SBP_LOWERTRACKHORZ' -> 16r4.
			'SBP_LOWERTRACKVERT' -> 16r6.
			'SBP_SIZEBOX' -> 16rA.
			'SBP_THUMBBTNHORZ' -> 16r2.
			'SBP_THUMBBTNVERT' -> 16r3.
			'SBP_UPPERTRACKHORZ' -> 16r5.
			'SBP_UPPERTRACKVERT' -> 16r7.
			'SBS_DISABLED' -> 16r4.
			'SBS_HOT' -> 16r2.
			'SBS_NORMAL' -> 16r1.
			'SBS_PUSHED' -> 16r3.
			'SCRBS_DISABLED' -> 16r4.
			'SCRBS_HOT' -> 16r2.
			'SCRBS_NORMAL' -> 16r1.
			'SCRBS_PRESSED' -> 16r3.
			'SP_GRIPPER' -> 16r3.
			'SP_GRIPPERPANE' -> 16r2.
			'SP_PANE' -> 16r1.
			'SPLITS_NORMAL' -> 16r1.
			'SPLITSV_NORMAL' -> 16r1.
			'SPLS_HOT' -> 16r2.
			'SPLS_NORMAL' -> 16r1.
			'SPLS_PRESSED' -> 16r3.
			'SPNP_DOWN' -> 16r2.
			'SPNP_DOWNHORZ' -> 16r4.
			'SPNP_UP' -> 16r1.
			'SPNP_UPHORZ' -> 16r3.
			'SPP_LOGOFF' -> 16r8.
			'SPP_LOGOFFBUTTONS' -> 16r9.
			'SPP_MOREPROGRAMS' -> 16r2.
			'SPP_MOREPROGRAMSARROW' -> 16r3.
			'SPP_PLACESLIST' -> 16r6.
			'SPP_PLACESLISTSEPARATOR' -> 16r7.
			'SPP_PREVIEW' -> 16rB.
			'SPP_PROGLIST' -> 16r4.
			'SPP_PROGLISTSEPARATOR' -> 16r5.
			'SPP_USERPANE' -> 16r1.
			'SPP_USERPICTURE' -> 16rA.
			'SPS_HOT' -> 16r2.
			'SPS_NORMAL' -> 16r1.
			'SPS_PRESSED' -> 16r3.
			'ST_STRETCH' -> 16r1.
			'ST_TILE' -> 16r2.
			'ST_TRUESIZE' -> 16r0.
			'STAP_ALLOW_CONTROLS' -> 16r2.
			'STAP_ALLOW_NONCLIENT' -> 16r1.
			'STAP_ALLOW_WEBCONTENT' -> 16r4.
			'SZB_LEFTALIGN' -> 16r2.
			'SZB_RIGHTALIGN' -> 16r1.
			'TABP_BODY' -> 16rA.
			'TABP_PANE' -> 16r9.
			'TABP_TABITEM' -> 16r1.
			'TABP_TABITEMBOTHEDGE' -> 16r4.
			'TABP_TABITEMLEFTEDGE' -> 16r2.
			'TABP_TABITEMRIGHTEDGE' -> 16r3.
			'TABP_TOPTABITEM' -> 16r5.
			'TABP_TOPTABITEMBOTHEDGE' -> 16r8.
			'TABP_TOPTABITEMLEFTEDGE' -> 16r6.
			'TABP_TOPTABITEMRIGHTEDGE' -> 16r7.
			'TBP_BACKGROUNDBOTTOM' -> 16r1.
			'TBP_BACKGROUNDLEFT' -> 16r4.
			'TBP_BACKGROUNDRIGHT' -> 16r2.
			'TBP_BACKGROUNDTOP' -> 16r3.
			'TBP_SIZINGBARBOTTOM' -> 16r5.
			'TBP_SIZINGBARLEFT' -> 16r8.
			'TBP_SIZINGBARRIGHT' -> 16r6.
			'TBP_SIZINGBARTOP' -> 16r7.
			'TDP_FLASHBUTTON' -> 16r2.
			'TDP_FLASHBUTTONGROUPMENU' -> 16r3.
			'TDP_GROUPCOUNT' -> 16r1.
			'TIBES_DISABLED' -> 16r4.
			'TIBES_FOCUSED' -> 16r5.
			'TIBES_HOT' -> 16r2.
			'TIBES_NORMAL' -> 16r1.
			'TIBES_SELECTED' -> 16r3.
			'TILES_DISABLED' -> 16r4.
			'TILES_FOCUSED' -> 16r5.
			'TILES_HOT' -> 16r2.
			'TILES_NORMAL' -> 16r1.
			'TILES_SELECTED' -> 16r3.
			'TIRES_DISABLED' -> 16r4.
			'TIRES_FOCUSED' -> 16r5.
			'TIRES_HOT' -> 16r2.
			'TIRES_NORMAL' -> 16r1.
			'TIRES_SELECTED' -> 16r3.
			'TIS_DISABLED' -> 16r4.
			'TIS_FOCUSED' -> 16r5.
			'TIS_HOT' -> 16r2.
			'TIS_NORMAL' -> 16r1.
			'TIS_SELECTED' -> 16r3.
			'TKP_THUMB' -> 16r3.
			'TKP_THUMBBOTTOM' -> 16r4.
			'TKP_THUMBLEFT' -> 16r7.
			'TKP_THUMBRIGHT' -> 16r8.
			'TKP_THUMBTOP' -> 16r5.
			'TKP_THUMBVERT' -> 16r6.
			'TKP_TICS' -> 16r9.
			'TKP_TICSVERT' -> 16rA.
			'TKP_TRACK' -> 16r1.
			'TKP_TRACKVERT' -> 16r2.
			'TKS_NORMAL' -> 16r1.
			'TMT_ACCENTCOLORHINT' -> 16rEEF.
			'TMT_ACTIVEBORDER' -> 16r64B.
			'TMT_ACTIVECAPTION' -> 16r643.
			'TMT_ALPHALEVEL' -> 16r962.
			'TMT_ALPHATHRESHOLD' -> 16r96F.
			'TMT_ALWAYSSHOWSIZINGBAR' -> 16r8A0.
			'TMT_APPWORKSPACE' -> 16r64D.
			'TMT_AUTHOR' -> 16r25C.
			'TMT_AUTOSIZE' -> 16r89A.
			'TMT_BACKGROUND' -> 16r642.
			'TMT_BGFILL' -> 16r89D.
			'TMT_BGTYPE' -> 16rFA1.
			'TMT_BLENDCOLOR' -> 16r138B.
			'TMT_BODYTEXTCOLOR' -> 16rEF3.
			'TMT_BOOL' -> 16rCB.
			'TMT_BORDERCOLOR' -> 16rED9.
			'TMT_BORDERCOLORHINT' -> 16rEEE.
			'TMT_BORDERONLY' -> 16r89B.
			'TMT_BORDERSIZE' -> 16r963.
			'TMT_BORDERTYPE' -> 16rFA2.
			'TMT_BTNFACE' -> 16r650.
			'TMT_BTNHIGHLIGHT' -> 16r655.
			'TMT_BTNSHADOW' -> 16r651.
			'TMT_BTNTEXT' -> 16r653.
			'TMT_BUTTONALTERNATEFACE' -> 16r65A.
			'TMT_CAPTIONBARHEIGHT' -> 16r4B5.
			'TMT_CAPTIONBARWIDTH' -> 16r4B4.
			'TMT_CAPTIONFONT' -> 16r321.
			'TMT_CAPTIONMARGINS' -> 16rE13.
			'TMT_CAPTIONTEXT' -> 16r64A.
			'TMT_CHARSET' -> 16r193.
			'TMT_COLOR' -> 16rCC.
			'TMT_COLORSCHEMES' -> 16r191.
			'TMT_COMPANY' -> 16r25B.
			'TMT_COMPOSITED' -> 16r89C.
			'TMT_CONTENTALIGNMENT' -> 16rFA6.
			'TMT_CONTENTMARGINS' -> 16rE12.
			'TMT_COPYRIGHT' -> 16r25D.
			'TMT_CSSNAME' -> 16r579.
			'TMT_DEFAULTPANESIZE' -> 16r138A.
			'TMT_DESCRIPTION' -> 16r260.
			'TMT_DISPLAYNAME' -> 16r259.
			'TMT_DKSHADOW3D' -> 16r656.
			'TMT_EDGEDKSHADOWCOLOR' -> 16rEDF.
			'TMT_EDGEFILLCOLOR' -> 16rEE0.
			'TMT_EDGEHIGHLIGHTCOLOR' -> 16rEDD.
			'TMT_EDGELIGHTCOLOR' -> 16rEDC.
			'TMT_EDGESHADOWCOLOR' -> 16rEDE.
			'TMT_FILENAME' -> 16rCE.
			'TMT_FILLCOLOR' -> 16rEDA.
			'TMT_FILLCOLORHINT' -> 16rEED.
			'TMT_FILLTYPE' -> 16rFA3.
			'TMT_FLATMENUS' -> 16r3E9.
			'TMT_FONT' -> 16rD2.
			'TMT_FROMCOLOR1' -> 16r7D1.
			'TMT_FROMCOLOR2' -> 16r7D2.
			'TMT_FROMCOLOR3' -> 16r7D3.
			'TMT_FROMCOLOR4' -> 16r7D4.
			'TMT_FROMCOLOR5' -> 16r7D5.
			'TMT_FROMHUE1' -> 16r709.
			'TMT_FROMHUE2' -> 16r70A.
			'TMT_FROMHUE3' -> 16r70B.
			'TMT_FROMHUE4' -> 16r70C.
			'TMT_FROMHUE5' -> 16r70D.
			'TMT_GLOWCOLOR' -> 16rEE8.
			'TMT_GLYPHFONT' -> 16rA29.
			'TMT_GLYPHFONTSIZINGTYPE' -> 16rFAE.
			'TMT_GLYPHIMAGEFILE' -> 16rBC0.
			'TMT_GLYPHINDEX' -> 16r972.
			'TMT_GLYPHONLY' -> 16r89F.
			'TMT_GLYPHTEXTCOLOR' -> 16rEEB.
			'TMT_GLYPHTRANSPARENT' -> 16r89E.
			'TMT_GLYPHTRANSPARENTCOLOR' -> 16rEEC.
			'TMT_GLYPHTYPE' -> 16rFAC.
			'TMT_GRADIENTACTIVECAPTION' -> 16r65C.
			'TMT_GRADIENTCOLOR1' -> 16rEE2.
			'TMT_GRADIENTCOLOR2' -> 16rEE3.
			'TMT_GRADIENTCOLOR3' -> 16rEE4.
			'TMT_GRADIENTCOLOR4' -> 16rEE5.
			'TMT_GRADIENTCOLOR5' -> 16rEE6.
			'TMT_GRADIENTINACTIVECAPTION' -> 16r65D.
			'TMT_GRADIENTRATIO1' -> 16r966.
			'TMT_GRADIENTRATIO2' -> 16r967.
			'TMT_GRADIENTRATIO3' -> 16r968.
			'TMT_GRADIENTRATIO4' -> 16r969.
			'TMT_GRADIENTRATIO5' -> 16r96A.
			'TMT_GRAYTEXT' -> 16r652.
			'TMT_HALIGN' -> 16rFA5.
			'TMT_HEIGHT' -> 16r971.
			'TMT_HIGHLIGHT' -> 16r64E.
			'TMT_HIGHLIGHTTEXT' -> 16r64F.
			'TMT_HOTTRACKING' -> 16r65B.
			'TMT_ICONEFFECT' -> 16rFA9.
			'TMT_ICONTITLEFONT' -> 16r326.
			'TMT_IMAGECOUNT' -> 16r961.
			'TMT_IMAGEFILE' -> 16rBB9.
			'TMT_IMAGEFILE1' -> 16rBBA.
			'TMT_IMAGEFILE2' -> 16rBBB.
			'TMT_IMAGEFILE3' -> 16rBBC.
			'TMT_IMAGEFILE4' -> 16rBBD.
			'TMT_IMAGEFILE5' -> 16rBBE.
			'TMT_IMAGELAYOUT' -> 16rFAB.
			'TMT_IMAGESELECTTYPE' -> 16rFAD.
			'TMT_INACTIVEBORDER' -> 16r64C.
			'TMT_INACTIVECAPTION' -> 16r644.
			'TMT_INACTIVECAPTIONTEXT' -> 16r654.
			'TMT_INFOBK' -> 16r659.
			'TMT_INFOTEXT' -> 16r658.
			'TMT_INT' -> 16rCA.
			'TMT_INTEGRALSIZING' -> 16r8A3.
			'TMT_INTLIST' -> 16rD3.
			'TMT_LIGHT3D' -> 16r657.
			'TMT_MARGINS' -> 16rCD.
			'TMT_MENU' -> 16r645.
			'TMT_MENUBAR' -> 16r65F.
			'TMT_MENUBARHEIGHT' -> 16r4B9.
			'TMT_MENUBARWIDTH' -> 16r4B8.
			'TMT_MENUFONT' -> 16r323.
			'TMT_MENUHILIGHT' -> 16r65E.
			'TMT_MENUTEXT' -> 16r648.
			'TMT_MINCOLORDEPTH' -> 16r515.
			'TMT_MINDPI1' -> 16r974.
			'TMT_MINDPI2' -> 16r975.
			'TMT_MINDPI3' -> 16r976.
			'TMT_MINDPI4' -> 16r977.
			'TMT_MINDPI5' -> 16r978.
			'TMT_MINSIZE' -> 16rD4B.
			'TMT_MINSIZE1' -> 16rD4C.
			'TMT_MINSIZE2' -> 16rD4D.
			'TMT_MINSIZE3' -> 16rD4E.
			'TMT_MINSIZE4' -> 16rD4F.
			'TMT_MINSIZE5' -> 16rD50.
			'TMT_MIRRORIMAGE' -> 16r8A1.
			'TMT_MSGBOXFONT' -> 16r325.
			'TMT_NORMALSIZE' -> 16rD51.
			'TMT_OFFSET' -> 16rD49.
			'TMT_OFFSETTYPE' -> 16rFA8.
			'TMT_POSITION' -> 16rD0.
			'TMT_PROGRESSCHUNKSIZE' -> 16r96B.
			'TMT_PROGRESSSPACESIZE' -> 16r96C.
			'TMT_RECT' -> 16rD1.
			'TMT_ROUNDCORNERHEIGHT' -> 16r965.
			'TMT_ROUNDCORNERWIDTH' -> 16r964.
			'TMT_SATURATION' -> 16r96D.
			'TMT_SCROLLBAR' -> 16r641.
			'TMT_SCROLLBARHEIGHT' -> 16r4B3.
			'TMT_SCROLLBARWIDTH' -> 16r4B2.
			'TMT_SHADOWCOLOR' -> 16rEE7.
			'TMT_SIZE' -> 16rCF.
			'TMT_SIZES' -> 16r192.
			'TMT_SIZINGBORDERWIDTH' -> 16r4B1.
			'TMT_SIZINGMARGINS' -> 16rE11.
			'TMT_SIZINGTYPE' -> 16rFA4.
			'TMT_SMALLCAPTIONFONT' -> 16r322.
			'TMT_SMCAPTIONBARHEIGHT' -> 16r4B7.
			'TMT_SMCAPTIONBARWIDTH' -> 16r4B6.
			'TMT_SOURCEGROW' -> 16r8A4.
			'TMT_SOURCESHRINK' -> 16r8A5.
			'TMT_STATUSFONT' -> 16r324.
			'TMT_STOCKIMAGEFILE' -> 16rBBF.
			'TMT_STRING' -> 16rC9.
			'TMT_TEXT' -> 16rC81.
			'TMT_TEXTBORDERCOLOR' -> 16rEE9.
			'TMT_TEXTBORDERSIZE' -> 16r96E.
			'TMT_TEXTCOLOR' -> 16rEDB.
			'TMT_TEXTSHADOWCOLOR' -> 16rEEA.
			'TMT_TEXTSHADOWOFFSET' -> 16rD4A.
			'TMT_TEXTSHADOWTYPE' -> 16rFAA.
			'TMT_TOCOLOR1' -> 16r7D6.
			'TMT_TOCOLOR2' -> 16r7D7.
			'TMT_TOCOLOR3' -> 16r7D8.
			'TMT_TOCOLOR4' -> 16r7D9.
			'TMT_TOCOLOR5' -> 16r7DA.
			'TMT_TOHUE1' -> 16r70E.
			'TMT_TOHUE2' -> 16r70F.
			'TMT_TOHUE3' -> 16r710.
			'TMT_TOHUE4' -> 16r711.
			'TMT_TOHUE5' -> 16r712.
			'TMT_TOOLTIP' -> 16r25A.
			'TMT_TRANSPARENT' -> 16r899.
			'TMT_TRANSPARENTCOLOR' -> 16rEE1.
			'TMT_TRUESIZESCALINGTYPE' -> 16rFAF.
			'TMT_TRUESIZESTRETCHMARK' -> 16r973.
			'TMT_UNIFORMSIZING' -> 16r8A2.
			'TMT_URL' -> 16r25E.
			'TMT_USERPICTURE' -> 16r1389.
			'TMT_VALIGN' -> 16rFA7.
			'TMT_VERSION' -> 16r25F.
			'TMT_WIDTH' -> 16r970.
			'TMT_WINDOW' -> 16r646.
			'TMT_WINDOWFRAME' -> 16r647.
			'TMT_WINDOWTEXT' -> 16r649.
			'TMT_XMLNAME' -> 16r57A.
			'TNP_ANIMBACKGROUND' -> 16r2.
			'TNP_BACKGROUND' -> 16r1.
			'TP_BUTTON' -> 16r1.
			'TP_DROPDOWNBUTTON' -> 16r2.
			'TP_SEPARATOR' -> 16r5.
			'TP_SEPARATORVERT' -> 16r6.
			'TP_SPLITBUTTON' -> 16r3.
			'TP_SPLITBUTTONDROPDOWN' -> 16r4.
			'TREIS_DISABLED' -> 16r4.
			'TREIS_HOT' -> 16r2.
			'TREIS_NORMAL' -> 16r1.
			'TREIS_SELECTED' -> 16r3.
			'TREIS_SELECTEDNOTFOCUS' -> 16r5.
			'TRS_NORMAL' -> 16r1.
			'TRVS_NORMAL' -> 16r1.
			'TS_CHECKED' -> 16r5.
			'TS_DISABLED' -> 16r4.
			'TS_DRAW' -> 16r2.
			'TS_HOT' -> 16r2.
			'TS_HOTCHECKED' -> 16r6.
			'TS_MIN' -> 16r0.
			'TS_NORMAL' -> 16r1.
			'TS_PRESSED' -> 16r3.
			'TS_TRUE' -> 16r1.
			'TSS_NORMAL' -> 16r1.
			'TSST_DPI' -> 16r2.
			'TSST_NONE' -> 16r0.
			'TSST_SIZE' -> 16r1.
			'TST_CONTINUOUS' -> 16r2.
			'TST_NONE' -> 16r0.
			'TST_SINGLE' -> 16r1.
			'TSVS_NORMAL' -> 16r1.
			'TTBS_LINK' -> 16r2.
			'TTBS_NORMAL' -> 16r1.
			'TTCS_HOT' -> 16r2.
			'TTCS_NORMAL' -> 16r1.
			'TTCS_PRESSED' -> 16r3.
			'TTIBES_DISABLED' -> 16r4.
			'TTIBES_FOCUSED' -> 16r5.
			'TTIBES_HOT' -> 16r2.
			'TTIBES_NORMAL' -> 16r1.
			'TTIBES_SELECTED' -> 16r3.
			'TTILES_DISABLED' -> 16r4.
			'TTILES_FOCUSED' -> 16r5.
			'TTILES_HOT' -> 16r2.
			'TTILES_NORMAL' -> 16r1.
			'TTILES_SELECTED' -> 16r3.
			'TTIRES_DISABLED' -> 16r4.
			'TTIRES_FOCUSED' -> 16r5.
			'TTIRES_HOT' -> 16r2.
			'TTIRES_NORMAL' -> 16r1.
			'TTIRES_SELECTED' -> 16r3.
			'TTIS_DISABLED' -> 16r4.
			'TTIS_FOCUSED' -> 16r5.
			'TTIS_HOT' -> 16r2.
			'TTIS_NORMAL' -> 16r1.
			'TTIS_SELECTED' -> 16r3.
			'TTP_BALLOON' -> 16r3.
			'TTP_BALLOONTITLE' -> 16r4.
			'TTP_CLOSE' -> 16r5.
			'TTP_STANDARD' -> 16r1.
			'TTP_STANDARDTITLE' -> 16r2.
			'TTSS_LINK' -> 16r2.
			'TTSS_NORMAL' -> 16r1.
			'TUBS_DISABLED' -> 16r5.
			'TUBS_FOCUSED' -> 16r4.
			'TUBS_HOT' -> 16r2.
			'TUBS_NORMAL' -> 16r1.
			'TUBS_PRESSED' -> 16r3.
			'TUS_DISABLED' -> 16r5.
			'TUS_FOCUSED' -> 16r4.
			'TUS_HOT' -> 16r2.
			'TUS_NORMAL' -> 16r1.
			'TUS_PRESSED' -> 16r3.
			'TUTS_DISABLED' -> 16r5.
			'TUTS_FOCUSED' -> 16r4.
			'TUTS_HOT' -> 16r2.
			'TUTS_NORMAL' -> 16r1.
			'TUTS_PRESSED' -> 16r3.
			'TUVLS_DISABLED' -> 16r5.
			'TUVLS_FOCUSED' -> 16r4.
			'TUVLS_HOT' -> 16r2.
			'TUVLS_NORMAL' -> 16r1.
			'TUVLS_PRESSED' -> 16r3.
			'TUVRS_DISABLED' -> 16r5.
			'TUVRS_FOCUSED' -> 16r4.
			'TUVRS_HOT' -> 16r2.
			'TUVRS_NORMAL' -> 16r1.
			'TUVRS_PRESSED' -> 16r3.
			'TUVS_DISABLED' -> 16r5.
			'TUVS_FOCUSED' -> 16r4.
			'TUVS_HOT' -> 16r2.
			'TUVS_NORMAL' -> 16r1.
			'TUVS_PRESSED' -> 16r3.
			'TVP_BRANCH' -> 16r3.
			'TVP_GLYPH' -> 16r2.
			'TVP_TREEITEM' -> 16r1.
			'UPHZS_DISABLED' -> 16r4.
			'UPHZS_HOT' -> 16r2.
			'UPHZS_NORMAL' -> 16r1.
			'UPHZS_PRESSED' -> 16r3.
			'UPS_DISABLED' -> 16r4.
			'UPS_HOT' -> 16r2.
			'UPS_NORMAL' -> 16r1.
			'UPS_PRESSED' -> 16r3.
			'VA_BOTTOM' -> 16r2.
			'VA_CENTER' -> 16r1.
			'VA_TOP' -> 16r0.
			'VSS_DISABLED' -> 16r4.
			'VSS_HOT' -> 16r2.
			'VSS_NORMAL' -> 16r1.
			'VSS_PUSHED' -> 16r3.
			'VTS_DISABLED' -> 16r4.
			'VTS_HOT' -> 16r2.
			'VTS_NORMAL' -> 16r1.
			'VTS_PUSHED' -> 16r3.
			'WP_CAPTION' -> 16r1.
			'WP_CAPTIONSIZINGTEMPLATE' -> 16r1E.
			'WP_CLOSEBUTTON' -> 16r12.
			'WP_DIALOG' -> 16r1D.
			'WP_FRAMEBOTTOM' -> 16r9.
			'WP_FRAMEBOTTOMSIZINGTEMPLATE' -> 16r24.
			'WP_FRAMELEFT' -> 16r7.
			'WP_FRAMELEFTSIZINGTEMPLATE' -> 16r20.
			'WP_FRAMERIGHT' -> 16r8.
			'WP_FRAMERIGHTSIZINGTEMPLATE' -> 16r22.
			'WP_HELPBUTTON' -> 16r17.
			'WP_HORZSCROLL' -> 16r19.
			'WP_HORZTHUMB' -> 16r1A.
			'WP_MAXBUTTON' -> 16r11.
			'WP_MAXCAPTION' -> 16r5.
			'WP_MDICLOSEBUTTON' -> 16r14.
			'WP_MDIHELPBUTTON' -> 16r18.
			'WP_MDIMINBUTTON' -> 16r10.
			'WP_MDIRESTOREBUTTON' -> 16r16.
			'WP_MDISYSBUTTON' -> 16rE.
			'WP_MINBUTTON' -> 16rF.
			'WP_MINCAPTION' -> 16r3.
			'WP_RESTOREBUTTON' -> 16r15.
			'WP_SMALLCAPTION' -> 16r2.
			'WP_SMALLCAPTIONSIZINGTEMPLATE' -> 16r1F.
			'WP_SMALLCLOSEBUTTON' -> 16r13.
			'WP_SMALLFRAMEBOTTOM' -> 16rC.
			'WP_SMALLFRAMEBOTTOMSIZINGTEMPLATE' -> 16r25.
			'WP_SMALLFRAMELEFT' -> 16rA.
			'WP_SMALLFRAMELEFTSIZINGTEMPLATE' -> 16r21.
			'WP_SMALLFRAMERIGHT' -> 16rB.
			'WP_SMALLFRAMERIGHTSIZINGTEMPLATE' -> 16r23.
			'WP_SMALLMAXCAPTION' -> 16r6.
			'WP_SMALLMINCAPTION' -> 16r4.
			'WP_SYSBUTTON' -> 16rD.
			'WP_VERTSCROLL' -> 16r1B.
			'WP_VERTTHUMB' -> 16r1C
		}!

OS.ThemeLibrary guid: (Core.GUID fromString: '{fb91df3f-4cb4-48a2-adee-a75b9a4d30a2}')!

OS.ThemeLibrary comment: 'ThemeLibrary is the <ExternalLibrary> class to represent the dynamic link library, ''UXTHEME.DLL''. It was generated from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library. It contains methods for each of the functions defined by the corresponding module in that type library.

The type library contains the following helpstring for this module
	"Windows Theme Library. Only available in Windows XP and above."

Warning: This comment was automatically generated from the module''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	dllname("UXTHEME.DLL"), 
	uuid(FB91DF3F-4CB4-48A2-ADEE-A75B9A4D30A2), 
	helpstring("Windows Theme Library. Only available in Windows XP and above.")
]
module Theme
{
	[helpstring("Draw a grayed-out string")] const unsigned long DTT_GRAYED = 1;
	[helpstring("Theme background segment hit test flag (default)")] const unsigned long HTTB_BACKGROUNDSEG = 0;
	[helpstring("Fixed border hit test option")] const unsigned long HTTB_FIXEDBORDER = 2;
	[helpstring("Caption hit test option.")] const unsigned long HTTB_CAPTION = 4;
	[helpstring("Hit test left resizing border")] const unsigned long HTTB_RESIZINGBORDER_LEFT = 16;
	[helpstring("Hit test top resizing border")] const unsigned long HTTB_RESIZINGBORDER_TOP = 32;
	[helpstring("Hit test right resizing border")] const unsigned long HTTB_RESIZINGBORDER_RIGHT = 64;
	[helpstring("Hit test bottom resizing border")] const unsigned long HTTB_RESIZINGBORDER_BOTTOM = 128;
	[helpstring("Resizing border hit test flags")] const unsigned long HTTB_RESIZINGBORDER = 240;
	[helpstring("Resizing border is specified as a template, not just window edges.")] const unsigned long HTTB_SIZINGTEMPLATE = 256;
	[helpstring("Use system resizing border width rather than theme content margins.")] const unsigned long HTTB_SYSTEMSIZINGMARGINS = 512;
	[helpstring("disable background texturing")] const unsigned long ETDT_DISABLE = 1;
	[helpstring("enable the theme-defined dialog background texturing")] const unsigned long ETDT_ENABLE = 2;
	[helpstring("use the Tab texture (should be combined with ETDT_ENABLE)")] const unsigned long ETDT_USETABTEXTURE = 4;
	[helpstring("enable the theme-defined background texturing using the Tab texture")] const unsigned long ETDT_ENABLETAB = 6;
	const unsigned long STAP_ALLOW_NONCLIENT = 1;
	const unsigned long STAP_ALLOW_CONTROLS = 2;
	const unsigned long STAP_ALLOW_WEBCONTENT = 4;
	[helpstring("rcClip has been specified")] const unsigned long DTBG_CLIPRECT = 1;
	[helpstring("draw transparent/alpha images as solid")] const unsigned long DTBG_DRAWSOLID = 2;
	[helpstring("don''t draw border of part")] const unsigned long DTBG_OMITBORDER = 4;
	[helpstring("don''t draw content area of part")] const unsigned long DTBG_OMITCONTENT = 8;
	[helpstring("TRUE if calling to compute region")] const unsigned long DTBG_COMPUTINGREGION = 16;
	[helpstring("assume the hdc is mirrorred and flip images as appropriate (currently only supported for bgtype=imagefile)")] const unsigned long DTBG_MIRRORDC = 32;

	[entry(0x60000000), helpstring("Open the theme data for the specified HWND and semi-colon separated list of class names.")]
	HTHEME __stdcall OpenThemeData(
		[in]HANDLE hwnd,
		[in]LPWSTR pszClassList);
	[entry(0x60000001), helpstring("Closes the theme data handle.")]
	HRESULT __stdcall CloseThemeData(
		[in]HTHEME HTHEME);
	[entry(0x60000002), helpstring("Draws the theme-specified border and fill for the ''iPartId'' and ''iStateId''.")]
	HRESULT __stdcall DrawThemeBackground(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]RECT* pRect,
		[in]RECT* pClipRect);
	[entry(0x60000003), helpstring("Draws the text using the theme-specified color and font for the ''iPartId'' and ''iStateId''")]
	HRESULT __stdcall DrawThemeText(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]LPWSTR pszText,
		[in]int iCharCount,
		[in]unsigned long dwTextFlags,
		[in]unsigned long dwTextFlags2,
		[in]RECT* pRect);
	[entry(0x60000004), helpstring("Gets the size of the content for the theme-defined background.  This is usually the area inside the borders or Margins.")]
	HRESULT __stdcall GetThemeBackgroundContentRect(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]RECT* pBoundingRect,
		[out]RECT* pContentRect);
	[entry(0x60000005), helpstring("Calculates the size/location of the theme-specified background based on the ''pContentRect''.")]
	HRESULT __stdcall GetThemeBackgroundExtent(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]RECT* pContentRect,
		[out]RECT* pExtentRect);
	[entry(0x60000006), helpstring("Returns the specified size of the theme part")]
	HRESULT __stdcall GetThemePartSize(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]RECT* prc,
		[in]THEMESIZE eSize,
		[out]SIZE* psz);
	[entry(0x60000007), helpstring("Calculates the size/location of the specified text when rendered in the Theme Font")]
	HRESULT __stdcall GetThemeTextExtent(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]LPWSTR pszText,
		[in]int iCharCount,
		[in]unsigned long dwTextFlags,
		[in]RECT* pBoundingRect,
		[out]RECT* pExtentRect);
	[entry(0x60000008), helpstring("Returns info about the theme-specified font for the part/state passed in.")]
	HRESULT __stdcall GetThemeTextMetrics(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[out]TEXTMETRIC* ptm);
	[entry(0x60000009), helpstring("Computes the region for a regular or partially transparent theme-specified background that is bound by the specified ''pRect''.")]
	HRESULT __stdcall GetThemeBackgroundRegion(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]RECT* pRect,
		[out]long* pRegion);
	[entry(0x6000000a), helpstring("Returns a HitTestCode (a subset of the values returned by WM_NCHITTEST) for the point ''ptTest'' within the theme-specified background (bound by pRect).")]
	HRESULT __stdcall HitTestThemeBackground(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]unsigned long dwOptions,
		[in]RECT* pRect,
		[in]long hrgn,
		[in]POINT ptTest,
		[out]unsigned short* pwHitTestCode);
	[entry(0x6000000b), helpstring("Similar to the DrawEdge() API, but uses part colors and is high-DPI aware")]
	HRESULT __stdcall DrawThemeEdge(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]RECT* pDestRect,
		[in]unsigned int uEdge,
		[in]unsigned int uFlags,
		[out]RECT* pContentRect);
	[entry(0x6000000c), helpstring("Draws an image within an imagelist based on a (possible) theme-defined effect. ")]
	HRESULT __stdcall DrawThemeIcon(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]RECT* pRect,
		[in]HANDLE himl,
		[in]int iImageIndex);
	[entry(0x6000000d), helpstring("Returns TRUE if the theme has defined parameters for the specified ''iPartId'' and ''iStateId''.")]
	BOOL __stdcall IsThemePartDefined(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId);
	[entry(0x6000000e), helpstring("Returns TRUE if the theme specified background for the part/state has transparent pieces or alpha-blended pieces.")]
	BOOL __stdcall IsThemeBackgroundPartiallyTransparent(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId);
	[entry(0x6000000f), helpstring("Get the value for the specified COLOR property")]
	HRESULT __stdcall GetThemeColor(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]COLORREF* pColor);
	[entry(0x60000010), helpstring("Get the value for the specified metric/size property")]
	HRESULT __stdcall GetThemeMetric(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]int* piVal);
	[entry(0x60000011), helpstring("Get the value for the specified string property")]
	HRESULT __stdcall GetThemeString(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]LPWSTR pszBuff,
		[in]int cchMaxBuffChars);
	[entry(0x60000012), helpstring("Get the value for the specified BOOL property")]
	HRESULT __stdcall GetThemeBool(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]long* pfVal);
	[entry(0x60000013), helpstring("Get the value for the specified int property")]
	HRESULT __stdcall GetThemeInt(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]int* piVal);
	[entry(0x60000014), helpstring("Get the value for the specified ENUM property")]
	HRESULT __stdcall GetThemeEnumValue(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]int* piVal);
	[entry(0x60000015), helpstring("Get the value for the specified position property")]
	HRESULT __stdcall GetThemePosition(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]POINT* pPoint);
	[entry(0x60000016), helpstring("Get the value for the specified font property")]
	HRESULT __stdcall GetThemeFont(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]LOGFONT* pFont);
	[entry(0x60000017), helpstring("Get the value for the specified RECT property")]
	HRESULT __stdcall GetThemeRect(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]RECT* pRect);
	[entry(0x60000018), helpstring("Get the value for the specified MARGINS property")]
	HRESULT __stdcall GetThemeMargins(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[in]RECT* prc,
		[out]MARGINS* pMargins);
	[entry(0x60000019), helpstring("Get the value for the specified INTLIST struct")]
	HRESULT __stdcall GetThemeIntList(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]INTLIST* pIntList);
	[entry(0x6000001a), helpstring("Searches for the specified theme property and sets ''pOrigin'' to indicate where it was found (or not found)")]
	HRESULT __stdcall GetThemePropertyOrigin(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]PROPERTYORIGIN* pOrigin);
	[entry(0x6000001b), helpstring("Redirects an existing Window to use a different section of the current theme information than its class normally asks for")]
	HRESULT __stdcall SetWindowTheme(
		[in]HANDLE hwnd,
		[in]LPWSTR pszSubAppName,
		[in]LPWSTR pszSubIdList);
	[entry(0x6000001c), helpstring("Get the value for the specified FILENAME property")]
	HRESULT __stdcall GetThemeFilename(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]LPWSTR pszThemeFileName,
		[in]int cchMaxBuffChars);
	[entry(0x6000001d), helpstring("Get the value of the specified System color")]
	COLORREF __stdcall GetThemeSysColor(
		[in]HTHEME HTHEME,
		[in]int iColorId);
	[entry(0x6000001e), helpstring("Get the brush for the specified System color")]
	long __stdcall GetThemeSysColorBrush(
		[in]HTHEME HTHEME,
		[in]int iColorId);
	[entry(0x6000001f), helpstring("Get the boolean value of specified System metric")]
	BOOL __stdcall GetThemeSysBool(
		[in]HTHEME HTHEME,
		[in]int iBoolId);
	[entry(0x60000020), helpstring("Get the value of the specified System size metric. (scaled for the current logical screen dpi)")]
	int __stdcall GetThemeSysSize(
		[in]HTHEME HTHEME,
		[in]int iSizeId);
	[entry(0x60000021), helpstring("Get the LOGFONT for the specified System font.")]
	HRESULT __stdcall GetThemeSysFont(
		[in]HTHEME HTHEME,
		[in]int iFontId,
		[out]LOGFONT* plf);
	[entry(0x60000022), helpstring("Get the value of specified System string metric.")]
	HRESULT __stdcall GetThemeSysString(
		[in]HTHEME HTHEME,
		[in]int iStringId,
		[out]LPWSTR pszStringBuff,
		[in]int cchMaxStringChars);
	[entry(0x60000023), helpstring("Get the value of specified System int.")]
	HRESULT __stdcall GetThemeSysInt(
		[in]HTHEME HTHEME,
		[in]int iIntId,
		[out]int* piValue);
	[entry(0x60000024), helpstring("Can be used to test if a system theme is active for the current user session.")]
	BOOL __stdcall IsThemeActive();
	[entry(0x60000025), helpstring("Returns TRUE if a theme is active and available to the current process")]
	BOOL __stdcall IsAppThemed();
	[entry(0x60000026), helpstring("If window is themed, returns its most recent HTHEME from OpenThemeData() - otherwise, returns NULL.")]
	HTHEME __stdcall GetWindowTheme(
		[in]HANDLE hwnd);
	[entry(0x60000027), helpstring("Enables/disables dialog background theme.")]
	HRESULT __stdcall EnableThemeDialogTexture(
		[in]HANDLE hwnd,
		[in]unsigned long dwFlags);
	[entry(0x60000028), helpstring("Reports whether the dialog supports background texturing.")]
	BOOL __stdcall IsThemeDialogTextureEnabled(
		[in]HANDLE hwnd);
	[entry(0x60000029), helpstring("Returns the app property flags that control theming")]
	unsigned long __stdcall GetThemeAppProperties();
	[entry(0x6000002a), helpstring("Sets the flags that control theming within the app")]
	void __stdcall SetThemeAppProperties(
		[in]unsigned long dwFlags);
	[entry(0x6000002b), helpstring("Get the name of the current theme in-use. ")]
	HRESULT __stdcall GetCurrentThemeName(
		[out]LPWSTR pszThemeFileName,
		[in]int cchMaxNameChars,
		[out]LPWSTR pszColorBuff,
		[in]int cchMaxColorChars,
		[out]LPWSTR pszSizeBuff,
		[in]int cchMaxSizeChars);
	[entry(0x6000002c), helpstring("Get the value for the specified property name from the [documentation] section of the themes.ini file for the specified theme. ")]
	HRESULT __stdcall GetThemeDocumentationProperty(
		[in]LPWSTR pszThemeName,
		[in]LPWSTR pszPropertyName,
		[out]LPWSTR pszValueBuff,
		[in]int cchMaxValChars);
	[entry(0x6000002d), helpstring("Used by partially-transparent or alpha-blended child controls to draw the part of their parent that they appear in front of.")]
	HRESULT __stdcall DrawThemeParentBackground(
		[in]HANDLE hwnd,
		[in]HANDLE hDC,
		[in, optional]RECT* prc);
	[entry(0x6000002e), helpstring("Enables or disables themeing for the current user in the current and future sessions.")]
	HRESULT __stdcall EnableTheming(
		[in]BOOL fEnable);
	[entry(0x6000002f), helpstring("Draws the theme-specified border and fill for the ''iPartId'' and ''iStateId''.")]
	HRESULT __stdcall DrawThemeBackgroundEx(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]RECT* pRect,
		[in]DTBGOPTS* pOptions);
};
'!

!OS.ThemeLibrary categoriesForClass!External-Libraries-Win32! !

!OS.ThemeLibrary methodsFor!

beginBufferedAnimation: hwnd hdcTarget: hdcTarget prcTarget: prcTarget dwFormat: dwFormat pPaintParams: pPaintParams pAnimationParams: pAnimationParams phdcFrom: phdcFrom phdcTo: phdcTo
	"Invoke the BeginBufferedAnimation() function of the module wrapped by the receiver.

		HANDLE __stdcall BeginBufferedAnimation(
			[in]HWND HWND,
			[in]HDC hdcTarget,
			[in]RECTL* prcTarget,
			[in]BP_BUFFERFORMAT dwFormat,
			[in]BP_PAINTPARAMS* pPaintParams,
			[in]BP_ANIMATIONPARAMS* pAnimationParams,
			[out]HDC* phdcFrom,
			[out]HDC* phdcTo);"

	<stdcall: handle BeginBufferedAnimation handle handle RECTL* int32 BP_PAINTPARAMS* BP_ANIMATIONPARAMS* handle* handle*>
	^self invalidCall: _failureCode!

beginBufferedPaint: hdcTarget prcTarget: prcTarget dwFormat: dwFormat pPaintParams: pPaintParams phDC: phDC
	"Invoke the BeginBufferedPaint() function of the module wrapped by the receiver.
	Helpstring: Begins a buffered paint operation.

		HANDLE __stdcall BeginBufferedPaint(
			[in]HDC hdcTarget,
			[in]RECTL* prcTarget,
			[in]BP_BUFFERFORMAT dwFormat,
			[in]BP_PAINTPARAMS* pPaintParams,
			[out]HDC* phDC);"

	<stdcall: handle BeginBufferedPaint handle RECTL* int32 BP_PAINTPARAMS* handle*>
	^self invalidCall: _failureCode!

bufferedPaintClear: hBufferedPaint prc: prc
	"Invoke the BufferedPaintClear() function of the module wrapped by the receiver.
	Helpstring: Returns the target rectangle specified during BeginBufferedPaint.

		HRESULT __stdcall BufferedPaintClear(
			[in]HANDLE hBufferedPaint,
			[in, optional]RECTL* prc);"

	<stdcall: hresult BufferedPaintClear handle RECTL*>
	^self invalidCall: _failureCode!

bufferedPaintInit
	"Invoke the BufferedPaintInit() function of the module wrapped by the receiver.
	Helpstring: Initialize the Buffered Paint API.

		HRESULT __stdcall BufferedPaintInit();"

	<stdcall: hresult BufferedPaintInit>
	^self invalidCall: _failureCode!

bufferedPaintRenderAnimation: hwnd hdcTarget: hdcTarget
	"Invoke the BufferedPaintRenderAnimation() function of the module wrapped by the receiver.

		BOOL __stdcall BufferedPaintRenderAnimation(
			[in]HWND HWND,
			[in]HDC hdcTarget);"

	<stdcall: bool BufferedPaintRenderAnimation handle handle>
	^self invalidCall: _failureCode!

bufferedPaintSetAlpha: hBufferedPaint prc: prc alpha: alpha
	"Invoke the BufferedPaintSetAlpha() function of the module wrapped by the receiver.
	Helpstring: Returns the target rectangle specified during BeginBufferedPaint.

		HRESULT __stdcall BufferedPaintSetAlpha(
			[in]HANDLE hBufferedPaint,
			[in]RECTL* prc,
			[in]BYTE Alpha);"

	<stdcall: hresult BufferedPaintSetAlpha handle RECTL* uint8>
	^self invalidCall: _failureCode!

bufferedPaintStopAllAnimations: hwnd
	"Invoke the BufferedPaintStopAllAnimations() function of the module wrapped by the receiver.

		HRESULT __stdcall BufferedPaintStopAllAnimations(
			[in]HWND HWND);"

	<stdcall: hresult BufferedPaintStopAllAnimations handle>
	^self invalidCall: _failureCode!

bufferedPaintUnInit
	"Invoke the BufferedPaintUnInit() function of the module wrapped by the receiver.
	Helpstring: Uninitialize the Buffered Paint API.

		HRESULT __stdcall BufferedPaintUnInit();"

	"Ignore any errors from calling this function, as we call it on shutdown."

	<stdcall: int32 BufferedPaintUnInit>
	^self invalidCall: _failureCode!

closeThemeData: htheme
	"Invoke the CloseThemeData() function of the module wrapped by the receiver.
	Helpstring: Closes the theme data handle. Return value is HRESULT error code.

		long __stdcall CloseThemeData(
			[in]HTHEME HTHEME);"

	<stdcall: int32 CloseThemeData handle>
	^self invalidCall: _failureCode!

drawThemeBackground: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pRect: pRect pClipRect: pClipRect
	"Invoke the DrawThemeBackground() function of the module wrapped by the receiver.
	Helpstring: Draws the theme-specified border and fill for the 'iPartId' and 'iStateId'.

		HRESULT __stdcall DrawThemeBackground(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECTL* pRect,
			[in]RECTL* pClipRect);"

	<stdcall: hresult DrawThemeBackground handle handle int32 int32 RECTL* RECTL*>
	^self invalidCall: _failureCode!

drawThemeBackgroundEx: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pRect: pRect pOptions: pOptions
	"Invoke the DrawThemeBackgroundEx() function of the module wrapped by the receiver.
	Helpstring: Draws the theme-specified border and fill for the 'iPartId' and 'iStateId'.

		HRESULT __stdcall DrawThemeBackgroundEx(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECTL* pRect,
			[in]DTBGOPTS* pOptions);"

	<stdcall: hresult DrawThemeBackgroundEx handle handle int32 int32 RECTL* DTBGOPTS*>
	^self invalidCall: _failureCode!

drawThemeEdge: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pDestRect: pDestRect uEdge: uEdge uFlags: uFlags pContentRect: pContentRect
	"Invoke the DrawThemeEdge() function of the module wrapped by the receiver.
	Helpstring: Similar to the DrawEdge() API, but uses part colors and is high-DPI aware

		HRESULT __stdcall DrawThemeEdge(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECTL* pDestRect,
			[in]UINT uEdge,
			[in]UINT uFlags,
			[out]RECTL* pContentRect);"

	<stdcall: hresult DrawThemeEdge handle handle int32 int32 RECTL* uint32 uint32 RECTL*>
	^self invalidCall: _failureCode!

drawThemeIcon: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pRect: pRect himl: himl iImageIndex: iImageIndex
	"Invoke the DrawThemeIcon() function of the module wrapped by the receiver.
	Helpstring: Draws an image within an imagelist based on a (possible) theme-defined effect. 

		HRESULT __stdcall DrawThemeIcon(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECTL* pRect,
			[in]HIMAGELIST himl,
			[in]int iImageIndex);"

	<stdcall: hresult DrawThemeIcon handle handle int32 int32 RECTL* handle int32>
	^self invalidCall: _failureCode!

drawThemeParentBackground: hwnd hdc: hdc prc: prc
	"Invoke the DrawThemeParentBackground() function of the module wrapped by the receiver.
	Helpstring: Used by partially-transparent or alpha-blended child controls to draw the part of their parent that they appear in front of.

		HRESULT __stdcall DrawThemeParentBackground(
			[in]HWND HWND,
			[in]HDC HDC,
			[in, optional]RECTL* prc);"

	<stdcall: hresult DrawThemeParentBackground handle handle RECTL*>
	^self invalidCall: _failureCode!

drawThemeText: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pszText: pszText iCharCount: iCharCount dwTextFlags: dwTextFlags dwTextFlags2: dwTextFlags2 pRect: pRect
	"Invoke the DrawThemeText() function of the module wrapped by the receiver.
	Helpstring: Draws the text using the theme-specified color and font for the 'iPartId' and 'iStateId'

		HRESULT __stdcall DrawThemeText(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]LPWSTR pszText,
			[in]int iCharCount,
			[in]DWORD dwTextFlags,
			[in]DWORD dwTextFlags2,
			[in]RECTL* pRect);"

	<stdcall: hresult DrawThemeText handle handle int32 int32 lpwstr int32 uint32 uint32 RECTL*>
	^self invalidCall: _failureCode!

enableThemeDialogTexture: hwnd dwFlags: dwFlags
	"Invoke the EnableThemeDialogTexture() function of the module wrapped by the receiver.
	Helpstring: Enables/disables dialog background theme.

		HRESULT __stdcall EnableThemeDialogTexture(
			[in]HWND HWND,
			[in]DWORD dwFlags);"

	<stdcall: hresult EnableThemeDialogTexture handle uint32>
	^self invalidCall: _failureCode!

enableTheming: fEnable
	"Invoke the EnableTheming() function of the module wrapped by the receiver.
	Helpstring: Enables or disables themeing for the current user in the current and future sessions.

		HRESULT __stdcall EnableTheming(
			[in]BOOL fEnable);"

	<stdcall: hresult EnableTheming bool>
	^self invalidCall: _failureCode!

endBufferedAnimation: hBufferedPaint fUpdateTarget: fUpdateTarget
	"Invoke the EndBufferedAnimation() function of the module wrapped by the receiver.
	Helpstring: Ends a buffered animation operation.

		HRESULT __stdcall EndBufferedAnimation(
			[in]HANDLE hBufferedPaint,
			[in]BOOL fUpdateTarget);"

	<stdcall: hresult EndBufferedAnimation handle bool>
	^self invalidCall: _failureCode!

endBufferedPaint: hBufferedPaint fUpdateTarget: fUpdateTarget
	"Invoke the EndBufferedPaint() function of the module wrapped by the receiver.
	Helpstring: Ends a buffered paint operation.

		HRESULT __stdcall EndBufferedPaint(
			[in]HANDLE hBufferedPaint,
			[in]BOOL fUpdateTarget);"

	<stdcall: hresult EndBufferedPaint handle bool>
	^self invalidCall: _failureCode!

getBufferedPaintBits: hBufferedPaint ppbBuffer: ppbBuffer pcxRow: pcxRow
	"Invoke the GetBufferedPaintBits() function of the module wrapped by the receiver.
	Helpstring: Returns the target rectangle specified during BeginBufferedPaint.

		HRESULT __stdcall GetBufferedPaintBits(
			[in]HANDLE hBufferedPaint,
			[out]RGBQUAD** ppbBuffer,
			[out]int* pcxRow);"

	<stdcall: hresult GetBufferedPaintBits handle RGBQUAD** int32*>
	^self invalidCall: _failureCode!

getBufferedPaintDC: hBufferedPaint
	"Invoke the GetBufferedPaintDC() function of the module wrapped by the receiver.
	Helpstring: Returns the target rectangle specified during BeginBufferedPaint.

		HDC __stdcall GetBufferedPaintDC(
			[in]HANDLE hBufferedPaint);"

	<stdcall: handle GetBufferedPaintDC handle>
	^self invalidCall: _failureCode!

getBufferedPaintTargetDC: hBufferedPaint
	"Invoke the GetBufferedPaintTargetDC() function of the module wrapped by the receiver.
	Helpstring: Returns the target rectangle specified during BeginBufferedPaint.

		HDC __stdcall GetBufferedPaintTargetDC(
			[in]HANDLE hBufferedPaint);"

	<stdcall: handle GetBufferedPaintTargetDC handle>
	^self invalidCall: _failureCode!

getBufferedPaintTargetRect: hBufferedPaint prc: prc
	"Invoke the GetBufferedPaintTargetRect() function of the module wrapped by the receiver.
	Helpstring: Returns the target rectangle specified during BeginBufferedPaint.

		HRESULT __stdcall GetBufferedPaintTargetRect(
			[in]HANDLE hBufferedPaint,
			[out, retval]RECTL* prc);"

	<stdcall: hresult GetBufferedPaintTargetRect handle RECTL*>
	^self invalidCall: _failureCode!

getCurrentThemeName: pszThemeFileName cchMaxNameChars: cchMaxNameChars pszColorBuff: pszColorBuff cchMaxColorChars: cchMaxColorChars pszSizeBuff: pszSizeBuff cchMaxSizeChars: cchMaxSizeChars
	"Invoke the GetCurrentThemeName() function of the module wrapped by the receiver.
	Helpstring: Get the name of the current theme in-use. 

		HRESULT __stdcall GetCurrentThemeName(
			[out]LPWSTR pszThemeFileName,
			[in]int cchMaxNameChars,
			[out]LPWSTR pszColorBuff,
			[in]int cchMaxColorChars,
			[out]LPWSTR pszSizeBuff,
			[in]int cchMaxSizeChars);"

	<stdcall: hresult GetCurrentThemeName lpwstr int32 lpwstr int32 lpwstr int32>
	^self invalidCall: _failureCode!

getThemeAppProperties
	"Invoke the GetThemeAppProperties() function of the module wrapped by the receiver.
	Helpstring: Returns the app property flags that control theming

		DWORD __stdcall GetThemeAppProperties();"

	<stdcall: uint32 GetThemeAppProperties>
	^self invalidCall: _failureCode!

getThemeBackgroundContentRect: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pBoundingRect: pBoundingRect pContentRect: pContentRect
	"Invoke the GetThemeBackgroundContentRect() function of the module wrapped by the receiver.
	Helpstring: Gets the size of the content for the theme-defined background.  This is usually the area inside the borders or Margins.

		HRESULT __stdcall GetThemeBackgroundContentRect(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECTL* pBoundingRect,
			[out]RECTL* pContentRect);"

	<stdcall: hresult GetThemeBackgroundContentRect handle handle int32 int32 RECTL* RECTL*>
	^self invalidCall: _failureCode!

getThemeBackgroundExtent: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pContentRect: pContentRect pExtentRect: pExtentRect
	"Invoke the GetThemeBackgroundExtent() function of the module wrapped by the receiver.
	Helpstring: Calculates the size/location of the theme-specified background based on the 'pContentRect'.

		HRESULT __stdcall GetThemeBackgroundExtent(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECTL* pContentRect,
			[out]RECTL* pExtentRect);"

	<stdcall: hresult GetThemeBackgroundExtent handle handle int32 int32 RECTL* RECTL*>
	^self invalidCall: _failureCode!

getThemeBackgroundRegion: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pRect: pRect pRegion: pRegion
	"Invoke the GetThemeBackgroundRegion() function of the module wrapped by the receiver.
	Helpstring: Computes the region for a regular or partially transparent theme-specified background that is bound by the specified 'pRect'.

		HRESULT __stdcall GetThemeBackgroundRegion(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECTL* pRect,
			[out]HRGN* pRegion);"

	<stdcall: hresult GetThemeBackgroundRegion handle handle int32 int32 RECTL* handle*>
	^self invalidCall: _failureCode!

getThemeBool: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pfVal: pfVal
	"Invoke the GetThemeBool() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified BOOL property

		HRESULT __stdcall GetThemeBool(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]BOOL* pfVal);"

	<stdcall: hresult GetThemeBool handle int32 int32 int32 bool*>
	^self invalidCall: _failureCode!

getThemeColor: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pColor: pColor
	"Invoke the GetThemeColor() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified COLOR property

		HRESULT __stdcall GetThemeColor(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]COLORREF* pColor);"

	<stdcall: hresult GetThemeColor handle int32 int32 int32 uint32*>
	^self invalidCall: _failureCode!

getThemeDocumentationProperty: pszThemeName pszPropertyName: pszPropertyName pszValueBuff: pszValueBuff cchMaxValChars: cchMaxValChars
	"Invoke the GetThemeDocumentationProperty() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified property name from the [documentation] section of the themes.ini file for the specified theme. 

		HRESULT __stdcall GetThemeDocumentationProperty(
			[in]LPWSTR pszThemeName,
			[in]LPWSTR pszPropertyName,
			[out]LPWSTR pszValueBuff,
			[in]int cchMaxValChars);"

	<stdcall: hresult GetThemeDocumentationProperty lpwstr lpwstr lpwstr int32>
	^self invalidCall: _failureCode!

getThemeEnumValue: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId piVal: piVal
	"Invoke the GetThemeEnumValue() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified ENUM property

		HRESULT __stdcall GetThemeEnumValue(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]int* piVal);"

	<stdcall: hresult GetThemeEnumValue handle int32 int32 int32 int32*>
	^self invalidCall: _failureCode!

getThemeFilename: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pszThemeFileName: pszThemeFileName cchMaxBuffChars: cchMaxBuffChars
	"Invoke the GetThemeFilename() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified FILENAME property

		HRESULT __stdcall GetThemeFilename(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]LPWSTR pszThemeFileName,
			[in]int cchMaxBuffChars);"

	<stdcall: hresult GetThemeFilename handle int32 int32 int32 lpwstr int32>
	^self invalidCall: _failureCode!

getThemeFont: htheme hdc: hdc iPartId: iPartId iStateId: iStateId iPropId: iPropId pFont: pFont
	"Invoke the GetThemeFont() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified font property

		HRESULT __stdcall GetThemeFont(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]LOGFONTW* pFont);"

	<stdcall: hresult GetThemeFont handle handle int32 int32 int32 LOGFONTW*>
	^self invalidCall: _failureCode!

getThemeInt: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId piVal: piVal
	"Invoke the GetThemeInt() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified int property

		HRESULT __stdcall GetThemeInt(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]int* piVal);"

	<stdcall: hresult GetThemeInt handle int32 int32 int32 int32*>
	^self invalidCall: _failureCode!

getThemeMargins: htheme hdc: hdc iPartId: iPartId iStateId: iStateId iPropId: iPropId prc: prc pMargins: pMargins
	"Invoke the GetThemeMargins() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified MARGINS property

		HRESULT __stdcall GetThemeMargins(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[in]RECTL* prc,
			[out]MARGINS* pMargins);"

	<stdcall: hresult GetThemeMargins handle handle int32 int32 int32 RECTL* MARGINS*>
	^self invalidCall: _failureCode!

getThemeMetric: htheme hdc: hdc iPartId: iPartId iStateId: iStateId iPropId: iPropId piVal: piVal
	"Invoke the GetThemeMetric() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified metric/size property

		HRESULT __stdcall GetThemeMetric(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]int* piVal);"

	<stdcall: hresult GetThemeMetric handle handle int32 int32 int32 int32*>
	^self invalidCall: _failureCode!

getThemePartSize: htheme hdc: hdc iPartId: iPartId iStateId: iStateId prc: prc eSize: eSize psz: psz
	"Invoke the GetThemePartSize() function of the module wrapped by the receiver.
	Helpstring: Returns the specified size of the theme part

		HRESULT __stdcall GetThemePartSize(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECTL* prc,
			[in]THEMESIZE eSize,
			[out]SIZEL* psz);"

	<stdcall: hresult GetThemePartSize handle handle int32 int32 RECTL* int32 SIZEL*>
	^self invalidCall: _failureCode!

getThemePosition: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pPoint: pPoint
	"Invoke the GetThemePosition() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified position property

		HRESULT __stdcall GetThemePosition(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]POINTL* pPoint);"

	<stdcall: hresult GetThemePosition handle int32 int32 int32 POINTL*>
	^self invalidCall: _failureCode!

getThemePropertyOrigin: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pOrigin: pOrigin
	"Invoke the GetThemePropertyOrigin() function of the module wrapped by the receiver.
	Helpstring: Searches for the specified theme property and sets 'pOrigin' to indicate where it was found (or not found)

		HRESULT __stdcall GetThemePropertyOrigin(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]PROPERTYORIGIN* pOrigin);"

	<stdcall: hresult GetThemePropertyOrigin handle int32 int32 int32 int32*>
	^self invalidCall: _failureCode!

getThemeRect: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pRect: pRect
	"Invoke the GetThemeRect() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified RECTL property

		HRESULT __stdcall GetThemeRect(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]RECTL* pRect);"

	<stdcall: hresult GetThemeRect handle int32 int32 int32 RECTL*>
	^self invalidCall: _failureCode!

getThemeString: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pszBuff: pszBuff cchMaxBuffChars: cchMaxBuffChars
	"Invoke the GetThemeString() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified string property

		HRESULT __stdcall GetThemeString(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]LPWSTR pszBuff,
			[in]int cchMaxBuffChars);"

	<stdcall: hresult GetThemeString handle int32 int32 int32 lpwstr int32>
	^self invalidCall: _failureCode!

getThemeSysBool: htheme iBoolId: iBoolId
	"Invoke the GetThemeSysBool() function of the module wrapped by the receiver.
	Helpstring: Get the boolean value of specified System metric

		BOOL __stdcall GetThemeSysBool(
			[in]HTHEME HTHEME,
			[in]int iBoolId);"

	<stdcall: bool GetThemeSysBool handle int32>
	^self invalidCall: _failureCode!

getThemeSysColor: htheme iColorId: iColorId
	"Invoke the GetThemeSysColor() function of the module wrapped by the receiver.
	Helpstring: Get the value of the specified System color

		COLORREF __stdcall GetThemeSysColor(
			[in]HTHEME HTHEME,
			[in]int iColorId);"

	<stdcall: uint32 GetThemeSysColor handle int32>
	^self invalidCall: _failureCode!

getThemeSysColorBrush: htheme iColorId: iColorId
	"Invoke the GetThemeSysColorBrush() function of the module wrapped by the receiver.
	Helpstring: Get the brush for the specified System color

		HBRUSH __stdcall GetThemeSysColorBrush(
			[in]HTHEME HTHEME,
			[in]int iColorId);"

	<stdcall: handle GetThemeSysColorBrush handle int32>
	^self invalidCall: _failureCode!

getThemeSysFont: htheme iFontId: iFontId
	| logfont |
	logfont := LOGFONTW newBuffer.
	self
		getThemeSysFont: htheme
		iFontId: iFontId
		plf: logfont.
	^logfont!

getThemeSysFont: htheme iFontId: iFontId plf: plf
	"Invoke the GetThemeSysFont() function of the module wrapped by the receiver.
	Helpstring: Get the LOGFONT for the specified System font.

		HRESULT __stdcall GetThemeSysFont(
			[in]HTHEME HTHEME,
			[in]int iFontId,
			[out]LOGFONTW* plf);"

	<stdcall: hresult GetThemeSysFont handle int32 LOGFONTW*>
	^self invalidCall: _failureCode!

getThemeSysInt: htheme iIntId: iIntId piValue: piValue
	"Invoke the GetThemeSysInt() function of the module wrapped by the receiver.
	Helpstring: Get the value of specified System int.

		HRESULT __stdcall GetThemeSysInt(
			[in]HTHEME HTHEME,
			[in]int iIntId,
			[out]int* piValue);"

	<stdcall: hresult GetThemeSysInt handle int32 int32*>
	^self invalidCall: _failureCode!

getThemeSysSize: htheme iSizeId: iSizeId
	"Invoke the GetThemeSysSize() function of the module wrapped by the receiver.
	Helpstring: Get the value of the specified System size metric. (scaled for the current logical screen dpi)

		int __stdcall GetThemeSysSize(
			[in]HTHEME HTHEME,
			[in]int iSizeId);"

	<stdcall: int32 GetThemeSysSize handle int32>
	^self invalidCall: _failureCode!

getThemeSysString: htheme iStringId: iStringId pszStringBuff: pszStringBuff cchMaxStringChars: cchMaxStringChars
	"Invoke the GetThemeSysString() function of the module wrapped by the receiver.
	Helpstring: Get the value of specified System string metric.

		HRESULT __stdcall GetThemeSysString(
			[in]HTHEME HTHEME,
			[in]int iStringId,
			[out]LPWSTR pszStringBuff,
			[in]int cchMaxStringChars);"

	<stdcall: hresult GetThemeSysString handle int32 lpwstr int32>
	^self invalidCall: _failureCode!

getThemeTextExtent: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pszText: pszText iCharCount: iCharCount dwTextFlags: dwTextFlags pBoundingRect: pBoundingRect pExtentRect: pExtentRect
	"Invoke the GetThemeTextExtent() function of the module wrapped by the receiver.
	Helpstring: Calculates the size/location of the specified text when rendered in the Theme Font

		HRESULT __stdcall GetThemeTextExtent(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]LPWSTR pszText,
			[in]int iCharCount,
			[in]DWORD dwTextFlags,
			[in]RECTL* pBoundingRect,
			[out]RECTL* pExtentRect);"

	<stdcall: hresult GetThemeTextExtent handle handle int32 int32 lpwstr int32 uint32 RECTL* RECTL*>
	^self invalidCall: _failureCode!

getThemeTextMetrics: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pTM: pTM
	"Invoke the GetThemeTextMetrics() function of the module wrapped by the receiver.
	Helpstring: Returns info about the theme-specified font for the part/state passed in.

		HRESULT __stdcall GetThemeTextMetrics(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[out]TEXTMETRICW* pTM);"

	<stdcall: hresult GetThemeTextMetrics handle handle int32 int32 TEXTMETRICW*>
	^self invalidCall: _failureCode!

getWindowTheme: hwnd
	"Invoke the GetWindowTheme() function of the module wrapped by the receiver.
	Helpstring: If window is themed, returns its most recent HTHEME from OpenThemeData() - otherwise, returns NULL.

		HTHEME __stdcall GetWindowTheme(
			[in]HWND HWND);"

	<stdcall: handle GetWindowTheme handle>
	^self invalidCall: _failureCode!

hitTestThemeBackground: htheme hdc: hdc iPartId: iPartId iStateId: iStateId dwOptions: dwOptions pRect: pRect hrgn: hrgn ptTest: ptTest pwHitTestCode: pwHitTestCode
	"Invoke the HitTestThemeBackground() function of the module wrapped by the receiver.
	Helpstring: Returns a HitTestCode (a subset of the values returned by WM_NCHITTEST) for the point 'ptTest' within the theme-specified background (bound by pRect).

		HRESULT __stdcall HitTestThemeBackground(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]DWORD dwOptions,
			[in]RECTL* pRect,
			[in]HRGN HRGN,
			[in]POINTL ptTest,
			[out]WORD* pwHitTestCode);"

	<stdcall: hresult HitTestThemeBackground handle handle int32 int32 uint32 RECTL* handle POINTL uint16*>
	^self invalidCall: _failureCode!

isAppThemed
	"Invoke the IsAppThemed() function of the module wrapped by the receiver.
	Helpstring: Returns TRUE if a theme is active and available to the current process

		BOOL __stdcall IsAppThemed();"

	<stdcall: bool IsAppThemed>
	^self invalidCall: _failureCode!

isCompositionActive
	"Invoke the IsCompositionActive() function of the module wrapped by the receiver.
	Helpstring: Tells if the DWM is running, and composition effects are possible for this process (themes are active).

		BOOL __stdcall IsCompositionActive();"

	<stdcall: bool IsCompositionActive>
	^self invalidCall: _failureCode!

isThemeActive
	"Invoke the IsThemeActive() function of the module wrapped by the receiver.
	Helpstring: Can be used to test if a system theme is active for the current user session.

		BOOL __stdcall IsThemeActive();"

	<stdcall: bool IsThemeActive>
	^self invalidCall: _failureCode!

isThemeBackgroundPartiallyTransparent: htheme iPartId: iPartId iStateId: iStateId
	"Invoke the IsThemeBackgroundPartiallyTransparent() function of the module wrapped by the receiver.
	Helpstring: Returns TRUE if the theme specified background for the part/state has transparent pieces or alpha-blended pieces.

		BOOL __stdcall IsThemeBackgroundPartiallyTransparent(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId);"

	<stdcall: bool IsThemeBackgroundPartiallyTransparent handle int32 int32>
	^self invalidCall: _failureCode!

isThemeDialogTextureEnabled: hwnd
	"Invoke the IsThemeDialogTextureEnabled() function of the module wrapped by the receiver.
	Helpstring: Reports whether the dialog supports background texturing.

		BOOL __stdcall IsThemeDialogTextureEnabled(
			[in]HWND HWND);"

	<stdcall: bool IsThemeDialogTextureEnabled handle>
	^self invalidCall: _failureCode!

isThemePartDefined: htheme iPartId: iPartId iStateId: iStateId
	"Invoke the IsThemePartDefined() function of the module wrapped by the receiver.
	Helpstring: Returns TRUE if the theme has defined parameters for the specified 'iPartId' and 'iStateId'.

		BOOL __stdcall IsThemePartDefined(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId);"

	<stdcall: bool IsThemePartDefined handle int32 int32>
	^self invalidCall: _failureCode!

onExit
	"Private - Perform any uninitialization required at system shutdown time"

	self bufferedPaintUnInit!

onStartup
	"Private - Perform any initialization required at system startup time"

	self bufferedPaintInit!

openThemeData: hwnd pszClassList: pszClassList
	"Invoke the OpenThemeData() function of the module wrapped by the receiver.
	Helpstring: Open the theme data for the specified HWND and semi-colon separated list of class names.

		HTHEME __stdcall OpenThemeData(
			[in]HWND HWND,
			[in]LPWSTR pszClassList);"

	<stdcall: handle OpenThemeData handle lpwstr>
	^self invalidCall: _failureCode!

openThemeDataForDpi: hwnd pszClassList: pszClassList dpi: dpi
	"Invoke the OpenThemeData() function of the module wrapped by the receiver.
	Helpstring: Open the theme data for the specified HWND and semi-colon separated list of class names.

		HTHEME __stdcall OpenThemeData(
			[in]HWND HWND,
			[in]LPWSTR pszClassList
			[in]DWORD dpi
		);"

	<stdcall: handle OpenThemeDataForDpi handle lpwstr uint32>
	^self invalidCall: _failureCode!

refreshImmersiveColorPolicyState
	<stdcall: int32 104>
	^0!

setThemeAppProperties: dwFlags
	"Invoke the SetThemeAppProperties() function of the module wrapped by the receiver.
	Helpstring: Sets the flags that control theming within the app

		void __stdcall SetThemeAppProperties(
			[in]DWORD dwFlags);"

	<stdcall: void SetThemeAppProperties uint32>
	^self invalidCall: _failureCode!

setWindowTheme: hwnd pszSubAppName: pszSubAppName pszSubIdList: pszSubIdList
	"Invoke the SetWindowTheme() function of the module wrapped by the receiver.
	Helpstring: Redirects an existing Window to use a different section of the current theme information than its class normally asks for

		HRESULT __stdcall SetWindowTheme(
			[in]HWND HWND,
			[in]LPWSTR pszSubAppName,
			[in]LPWSTR pszSubIdList);"

	<stdcall: hresult SetWindowTheme handle lpwstr lpwstr>
	^self invalidCall: _failureCode!

shouldAppsUseDarkMode
	<stdcall: bool 132>
	^false
"
UxTheme shouldAppsUseDarkMode
"! !

!OS.ThemeLibrary categoriesForMethods!
beginBufferedAnimation:hdcTarget:prcTarget:dwFormat:pPaintParams:pAnimationParams:phdcFrom:phdcTo:!**auto generated**!public!win32 functions-visual styles! !
beginBufferedPaint:prcTarget:dwFormat:pPaintParams:phDC:!**auto generated**!public!win32 functions-visual styles! !
bufferedPaintClear:prc:!**auto generated**!public!win32 functions-visual styles! !
bufferedPaintInit!**auto generated**!public!win32 functions-visual styles! !
bufferedPaintRenderAnimation:hdcTarget:!**auto generated**!public!win32 functions-visual styles! !
bufferedPaintSetAlpha:prc:alpha:!**auto generated**!public!win32 functions-visual styles! !
bufferedPaintStopAllAnimations:!**auto generated**!public!win32 functions-visual styles! !
bufferedPaintUnInit!public!win32 functions-visual styles! !
closeThemeData:!public!win32 functions-visual styles! !
drawThemeBackground:hdc:iPartId:iStateId:pRect:pClipRect:!**auto generated**!public!win32 functions-visual styles! !
drawThemeBackgroundEx:hdc:iPartId:iStateId:pRect:pOptions:!**auto generated**!public!win32 functions-visual styles! !
drawThemeEdge:hdc:iPartId:iStateId:pDestRect:uEdge:uFlags:pContentRect:!**auto generated**!public!win32 functions-visual styles! !
drawThemeIcon:hdc:iPartId:iStateId:pRect:himl:iImageIndex:!**auto generated**!public!win32 functions-visual styles! !
drawThemeParentBackground:hdc:prc:!**auto generated**!public!win32 functions-visual styles! !
drawThemeText:hdc:iPartId:iStateId:pszText:iCharCount:dwTextFlags:dwTextFlags2:pRect:!**auto generated**!public!win32 functions-visual styles! !
enableThemeDialogTexture:dwFlags:!**auto generated**!public!win32 functions-visual styles! !
enableTheming:!**auto generated**!public!win32 functions-visual styles! !
endBufferedAnimation:fUpdateTarget:!public!win32 functions-visual styles! !
endBufferedPaint:fUpdateTarget:!**auto generated**!public!win32 functions-visual styles! !
getBufferedPaintBits:ppbBuffer:pcxRow:!**auto generated**!public!win32 functions-visual styles! !
getBufferedPaintDC:!**auto generated**!public!win32 functions-visual styles! !
getBufferedPaintTargetDC:!**auto generated**!public!win32 functions-visual styles! !
getBufferedPaintTargetRect:prc:!**auto generated**!public!win32 functions-visual styles! !
getCurrentThemeName:cchMaxNameChars:pszColorBuff:cchMaxColorChars:pszSizeBuff:cchMaxSizeChars:!**auto generated**!public!win32 functions-visual styles! !
getThemeAppProperties!**auto generated**!public!win32 functions-visual styles! !
getThemeBackgroundContentRect:hdc:iPartId:iStateId:pBoundingRect:pContentRect:!**auto generated**!public!win32 functions-visual styles! !
getThemeBackgroundExtent:hdc:iPartId:iStateId:pContentRect:pExtentRect:!**auto generated**!public!win32 functions-visual styles! !
getThemeBackgroundRegion:hdc:iPartId:iStateId:pRect:pRegion:!**auto generated**!public!win32 functions-visual styles! !
getThemeBool:iPartId:iStateId:iPropId:pfVal:!**auto generated**!public!win32 functions-visual styles! !
getThemeColor:iPartId:iStateId:iPropId:pColor:!**auto generated**!public!win32 functions-visual styles! !
getThemeDocumentationProperty:pszPropertyName:pszValueBuff:cchMaxValChars:!**auto generated**!public!win32 functions-visual styles! !
getThemeEnumValue:iPartId:iStateId:iPropId:piVal:!**auto generated**!public!win32 functions-visual styles! !
getThemeFilename:iPartId:iStateId:iPropId:pszThemeFileName:cchMaxBuffChars:!**auto generated**!public!win32 functions-visual styles! !
getThemeFont:hdc:iPartId:iStateId:iPropId:pFont:!**auto generated**!public!win32 functions-visual styles! !
getThemeInt:iPartId:iStateId:iPropId:piVal:!**auto generated**!public!win32 functions-visual styles! !
getThemeMargins:hdc:iPartId:iStateId:iPropId:prc:pMargins:!**auto generated**!public!win32 functions-visual styles! !
getThemeMetric:hdc:iPartId:iStateId:iPropId:piVal:!**auto generated**!public!win32 functions-visual styles! !
getThemePartSize:hdc:iPartId:iStateId:prc:eSize:psz:!**auto generated**!public!win32 functions-visual styles! !
getThemePosition:iPartId:iStateId:iPropId:pPoint:!**auto generated**!public!win32 functions-visual styles! !
getThemePropertyOrigin:iPartId:iStateId:iPropId:pOrigin:!**auto generated**!public!win32 functions-visual styles! !
getThemeRect:iPartId:iStateId:iPropId:pRect:!**auto generated**!public!win32 functions-visual styles! !
getThemeString:iPartId:iStateId:iPropId:pszBuff:cchMaxBuffChars:!**auto generated**!public!win32 functions-visual styles! !
getThemeSysBool:iBoolId:!**auto generated**!public!win32 functions-visual styles! !
getThemeSysColor:iColorId:!**auto generated**!public!win32 functions-visual styles! !
getThemeSysColorBrush:iColorId:!**auto generated**!public!win32 functions-visual styles! !
getThemeSysFont:iFontId:!public!win32 functions-visual styles! !
getThemeSysFont:iFontId:plf:!**auto generated**!public!win32 functions-visual styles! !
getThemeSysInt:iIntId:piValue:!**auto generated**!public!win32 functions-visual styles! !
getThemeSysSize:iSizeId:!**auto generated**!public!win32 functions-visual styles! !
getThemeSysString:iStringId:pszStringBuff:cchMaxStringChars:!**auto generated**!public!win32 functions-visual styles! !
getThemeTextExtent:hdc:iPartId:iStateId:pszText:iCharCount:dwTextFlags:pBoundingRect:pExtentRect:!**auto generated**!public!win32 functions-visual styles! !
getThemeTextMetrics:hdc:iPartId:iStateId:pTM:!**auto generated**!public!win32 functions-visual styles! !
getWindowTheme:!**auto generated**!public!win32 functions-visual styles! !
hitTestThemeBackground:hdc:iPartId:iStateId:dwOptions:pRect:hrgn:ptTest:pwHitTestCode:!**auto generated**!public!win32 functions-visual styles! !
isAppThemed!**auto generated**!public!win32 functions-visual styles! !
isCompositionActive!**auto generated**!public!win32 functions-visual styles! !
isThemeActive!**auto generated**!public!win32 functions-visual styles! !
isThemeBackgroundPartiallyTransparent:iPartId:iStateId:!**auto generated**!public!win32 functions-visual styles! !
isThemeDialogTextureEnabled:!**auto generated**!public!win32 functions-visual styles! !
isThemePartDefined:iPartId:iStateId:!**auto generated**!public!win32 functions-visual styles! !
onExit!event handling!private! !
onStartup!event handling!private! !
openThemeData:pszClassList:!**auto generated**!public!win32 functions-visual styles! !
openThemeDataForDpi:pszClassList:dpi:!**auto generated**!public!win32 functions-visual styles! !
refreshImmersiveColorPolicyState!public!undocumented dark mode APIs! !
setThemeAppProperties:!**auto generated**!public!win32 functions-visual styles! !
setWindowTheme:pszSubAppName:pszSubIdList:!**auto generated**!public!win32 functions-visual styles! !
shouldAppsUseDarkMode!public!undocumented dark mode APIs! !
!

!OS.ThemeLibrary class methodsFor!

fileName
	"Answer the host system file name for the library."

	^'uxtheme'
!

new
	^(SystemMetrics current hasThemes ifTrue: [self] ifFalse: [MockThemeLibrary]) basicNew!

sharedVariableName
	^#{OS.UxTheme}! !

!OS.ThemeLibrary class categoriesForMethods!
fileName!**auto generated**!constants!public! !
new!instance creation!public! !
sharedVariableName!constants!private! !
!

