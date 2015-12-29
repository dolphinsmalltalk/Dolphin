"Filed out from Dolphin Smalltalk X6.1"!

ItcWebAppInstaller subclass: #WikiDocInstaller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocInstaller guid: (GUID fromString: '{8E57D963-D5D7-428C-A38C-E5ECC55FA9BC}')!
WikiDocInstaller comment: ''!
!WikiDocInstaller categoriesForClass!Unclassified! !
!WikiDocInstaller methodsFor!

addAllInstallerFiles
	self
		addDirectories;
		addFile: self executableName from: self executableName;
		addDolphinX6Files;
		addHelperFiles;
		addImageFiles;
		"addCssFiles;"
		addJavascriptFiles;
		addNationalLanguageSupportFiles;
		addDirectoriesAndFilesForFCKEditors!

addAllInstallerFilesForFirstInstallation
	super addAllInstallerFilesForFirstInstallation.
	self
		addFile: 'WikiDoc License.rtf' from: 'distro\WikiDoc License.rtf';
		addFile: 'WikiDoc.cfg'
			from: 'distro\WikiDoc.cfg'
			flags: #('confirmoverwrite' 'uninsneveruninstall' 'onlyifdoesntexist')!

addCssAndJavascriptDirectories
	self
		addAppDirectory: 'http-root\css';
		addAppDirectory: 'http-root\scripts'!

addDirectories
	self
		addDirectory: self applicationPath;
		addAppDirectory: 'http-root';
		addAppDirectory: 'http-root\images';
		addAppDirectory: 'nls';
		addAppDirectory: 'temp';
		addCssAndJavascriptDirectories!

addDirectoriesAndFilesForFCKEditors
	self
		addAppDirectory: 'http-root\fckeditor';
		addAppDirectory: 'http-root\fckeditor\editor';
		addAppDirectory: 'http-root\fckeditor\editor\css';
		addAppDirectory: 'http-root\fckeditor\editor\dialog';
		addAppDirectory: 'http-root\fckeditor\editor\images';
		addAppDirectory: 'http-root\fckeditor\editor\js';
		addAppDirectory: 'http-root\fckeditor\editor\lang';
		addAppDirectory: 'http-root\fckeditor\editor\plugins';
		addAppDirectory: 'http-root\fckeditor\editor\skins';
		addAppDirectory: 'http-root\fckeditor\editor\css\behaviors';
		addAppDirectory: 'http-root\fckeditor\editor\css\images';
		addAppDirectory: 'http-root\fckeditor\editor\dialog\common';
		addAppDirectory: 'http-root\fckeditor\editor\dialog\fck_about';
		addAppDirectory: 'http-root\fckeditor\editor\dialog\fck_docprops';
		addAppDirectory: 'http-root\fckeditor\editor\dialog\fck_flash';
		addAppDirectory: 'http-root\fckeditor\editor\dialog\fck_image';
		addAppDirectory: 'http-root\fckeditor\editor\dialog\fck_link';
		addAppDirectory: 'http-root\fckeditor\editor\dialog\fck_select';
		addAppDirectory: 'http-root\fckeditor\editor\dialog\fck_spellerpages';
		addAppDirectory: 'http-root\fckeditor\editor\dialog\fck_template';
		addAppDirectory: 'http-root\fckeditor\editor\dialog\fck_universalkey';
		addAppDirectory: 'http-root\fckeditor\editor\dialog\common\images';
		addAppDirectory: 'http-root\fckeditor\editor\dialog\fck_spellerpages\spellerpages';
		addAppDirectory: 'http-root\fckeditor\editor\dialog\fck_spellerpages\spellerpages\server-scripts';
		addAppDirectory: 'http-root\fckeditor\editor\dialog\fck_template\images';
		addAppDirectory: 'http-root\fckeditor\editor\images\smiley';
		addAppDirectory: 'http-root\fckeditor\editor\images\smiley\msn';
		addAppDirectory: 'http-root\fckeditor\editor\plugins\autogrow';
		addAppDirectory: 'http-root\fckeditor\editor\plugins\placeholder';
		addAppDirectory: 'http-root\fckeditor\editor\plugins\simplecommands';
		addAppDirectory: 'http-root\fckeditor\editor\plugins\tablecommands';
		addAppDirectory: 'http-root\fckeditor\editor\plugins\placeholder\lang';
		addAppDirectory: 'http-root\fckeditor\editor\skins\default';
		addAppDirectory: 'http-root\fckeditor\editor\skins\office2003';
		addAppDirectory: 'http-root\fckeditor\editor\skins\silver';
		addAppDirectory: 'http-root\fckeditor\editor\skins\default\images';
		addAppDirectory: 'http-root\fckeditor\editor\skins\office2003\images';
		addAppDirectory: 'http-root\fckeditor\editor\skins\silver\images';
		addAppFile: 'http-root\fckeditor\fckconfig.js';
		addAppFile: 'http-root\fckeditor\fckeditor.js';
		addAppFile: 'http-root\fckeditor\fckstyles.xml';
		addAppFile: 'http-root\fckeditor\fcktemplates.xml';
		addAppFile: 'http-root\fckeditor\editor\fckblank.html';
		addAppFile: 'http-root\fckeditor\editor\fckdebug.html';
		addAppFile: 'http-root\fckeditor\editor\fckdialog.html';
		addAppFile: 'http-root\fckeditor\editor\fckeditor.html';
		addAppFile: 'http-root\fckeditor\editor\fckeditor.original.html';
		addAppFile: 'http-root\fckeditor\editor\css\fck_editorarea.css';
		addAppFile: 'http-root\fckeditor\editor\css\fck_internal.css';
		addAppFile: 'http-root\fckeditor\editor\css\fck_showtableborders_gecko.css';
		addAppFile: 'http-root\fckeditor\editor\css\behaviors\disablehandles.htc';
		addAppFile: 'http-root\fckeditor\editor\css\behaviors\hiddenfield.gif';
		addAppFile: 'http-root\fckeditor\editor\css\behaviors\hiddenfield.htc';
		addAppFile: 'http-root\fckeditor\editor\css\behaviors\showtableborders.htc';
		addAppFile: 'http-root\fckeditor\editor\css\images\fck_anchor.gif';
		addAppFile: 'http-root\fckeditor\editor\css\images\fck_flashlogo.gif';
		addAppFile: 'http-root\fckeditor\editor\css\images\fck_pagebreak.gif';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_about.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_anchor.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_button.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_checkbox.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_colorselector.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_docprops.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_find.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_flash.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_form.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_hiddenfield.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_image.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_link.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_listprop.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_paste.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_radiobutton.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_replace.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_select.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_smiley.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_source.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_specialchar.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_spellerpages.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_table.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_tablecell.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_template.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_textarea.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_textfield.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_universalkey.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\common\fcknumericfield.htc';
		addAppFile: 'http-root\fckeditor\editor\dialog\common\fck_dialog_common.css';
		addAppFile: 'http-root\fckeditor\editor\dialog\common\fck_dialog_common.js';
		addAppFile: 'http-root\fckeditor\editor\dialog\common\moz-bindings.xml';
		addAppFile: 'http-root\fckeditor\editor\dialog\common\images\locked.gif';
		addAppFile: 'http-root\fckeditor\editor\dialog\common\images\reset.gif';
		addAppFile: 'http-root\fckeditor\editor\dialog\common\images\unlocked.gif';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_about\lgpl.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_about\logo_fckeditor.gif';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_about\logo_fredck.gif';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_docprops\fck_document_preview.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_flash\fck_flash.js';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_flash\fck_flash_preview.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_image\fck_image.js';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_image\fck_image_preview.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_link\fck_link.js';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_select\fck_select.js';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_spellerpages\spellerpages\blank.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_spellerpages\spellerpages\controls.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_spellerpages\spellerpages\controlWindow.js';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_spellerpages\spellerpages\spellchecker.html';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_spellerpages\spellerpages\spellChecker.js';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_spellerpages\spellerpages\spellerStyle.css';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_spellerpages\spellerpages\wordWindow.js';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_spellerpages\spellerpages\server-scripts\spellchecker.cfm';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_spellerpages\spellerpages\server-scripts\spellchecker.php';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_spellerpages\spellerpages\server-scripts\spellchecker.pl';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_template\images\template1.gif';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_template\images\template2.gif';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_template\images\template3.gif';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_universalkey\00.gif';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_universalkey\data.js';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_universalkey\diacritic.js';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_universalkey\dialogue.js';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_universalkey\fck_universalkey.css';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_universalkey\keyboard_layout.gif';
		addAppFile: 'http-root\fckeditor\editor\dialog\fck_universalkey\multihexa.js';
		addAppFile: 'http-root\fckeditor\editor\images\anchor.gif';
		addAppFile: 'http-root\fckeditor\editor\images\arrow_ltr.gif';
		addAppFile: 'http-root\fckeditor\editor\images\arrow_rtl.gif';
		addAppFile: 'http-root\fckeditor\editor\images\spacer.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\angel_smile.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\angry_smile.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\broken_heart.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\cake.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\confused_smile.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\cry_smile.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\devil_smile.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\embaressed_smile.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\envelope.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\heart.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\kiss.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\lightbulb.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\omg_smile.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\regular_smile.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\sad_smile.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\shades_smile.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\teeth_smile.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\thumbs_down.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\thumbs_up.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\tounge_smile.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\whatchutalkingabout_smile.gif';
		addAppFile: 'http-root\fckeditor\editor\images\smiley\msn\wink_smile.gif';
		addAppFile: 'http-root\fckeditor\editor\js\fckeditorcode_gecko.js';
		addAppFile: 'http-root\fckeditor\editor\js\fckeditorcode_ie.js';
		addAppFile: 'http-root\fckeditor\editor\lang\ar.js';
		addAppFile: 'http-root\fckeditor\editor\lang\bg.js';
		addAppFile: 'http-root\fckeditor\editor\lang\bn.js';
		addAppFile: 'http-root\fckeditor\editor\lang\bs.js';
		addAppFile: 'http-root\fckeditor\editor\lang\ca.js';
		addAppFile: 'http-root\fckeditor\editor\lang\cs.js';
		addAppFile: 'http-root\fckeditor\editor\lang\da.js';
		addAppFile: 'http-root\fckeditor\editor\lang\de.js';
		addAppFile: 'http-root\fckeditor\editor\lang\el.js';
		addAppFile: 'http-root\fckeditor\editor\lang\en-au.js';
		addAppFile: 'http-root\fckeditor\editor\lang\en-ca.js';
		addAppFile: 'http-root\fckeditor\editor\lang\en-uk.js';
		addAppFile: 'http-root\fckeditor\editor\lang\en.js';
		addAppFile: 'http-root\fckeditor\editor\lang\eo.js';
		addAppFile: 'http-root\fckeditor\editor\lang\es.js';
		addAppFile: 'http-root\fckeditor\editor\lang\et.js';
		addAppFile: 'http-root\fckeditor\editor\lang\eu.js';
		addAppFile: 'http-root\fckeditor\editor\lang\fa.js';
		addAppFile: 'http-root\fckeditor\editor\lang\fi.js';
		addAppFile: 'http-root\fckeditor\editor\lang\fo.js';
		addAppFile: 'http-root\fckeditor\editor\lang\fr.js';
		addAppFile: 'http-root\fckeditor\editor\lang\gl.js';
		addAppFile: 'http-root\fckeditor\editor\lang\he.js';
		addAppFile: 'http-root\fckeditor\editor\lang\hi.js';
		addAppFile: 'http-root\fckeditor\editor\lang\hr.js';
		addAppFile: 'http-root\fckeditor\editor\lang\hu.js';
		addAppFile: 'http-root\fckeditor\editor\lang\it.js';
		addAppFile: 'http-root\fckeditor\editor\lang\ja.js';
		addAppFile: 'http-root\fckeditor\editor\lang\km.js';
		addAppFile: 'http-root\fckeditor\editor\lang\ko.js';
		addAppFile: 'http-root\fckeditor\editor\lang\lt.js';
		addAppFile: 'http-root\fckeditor\editor\lang\lv.js';
		addAppFile: 'http-root\fckeditor\editor\lang\mn.js';
		addAppFile: 'http-root\fckeditor\editor\lang\ms.js';
		addAppFile: 'http-root\fckeditor\editor\lang\nl.js';
		addAppFile: 'http-root\fckeditor\editor\lang\no.js';
		addAppFile: 'http-root\fckeditor\editor\lang\pl.js';
		addAppFile: 'http-root\fckeditor\editor\lang\pt-br.js';
		addAppFile: 'http-root\fckeditor\editor\lang\pt.js';
		addAppFile: 'http-root\fckeditor\editor\lang\ro.js';
		addAppFile: 'http-root\fckeditor\editor\lang\ru.js';
		addAppFile: 'http-root\fckeditor\editor\lang\sk.js';
		addAppFile: 'http-root\fckeditor\editor\lang\sl.js';
		addAppFile: 'http-root\fckeditor\editor\lang\sr-latn.js';
		addAppFile: 'http-root\fckeditor\editor\lang\sr.js';
		addAppFile: 'http-root\fckeditor\editor\lang\sv.js';
		addAppFile: 'http-root\fckeditor\editor\lang\th.js';
		addAppFile: 'http-root\fckeditor\editor\lang\tr.js';
		addAppFile: 'http-root\fckeditor\editor\lang\uk.js';
		addAppFile: 'http-root\fckeditor\editor\lang\vi.js';
		addAppFile: 'http-root\fckeditor\editor\lang\zh-cn.js';
		addAppFile: 'http-root\fckeditor\editor\lang\zh.js';
		addAppFile: 'http-root\fckeditor\editor\lang\_getfontformat.html';
		addAppFile: 'http-root\fckeditor\editor\lang\_translationstatus.txt';
		addAppFile: 'http-root\fckeditor\editor\plugins\autogrow\fckplugin.js';
		addAppFile: 'http-root\fckeditor\editor\plugins\placeholder\fckplugin.js';
		addAppFile: 'http-root\fckeditor\editor\plugins\placeholder\fck_placeholder.html';
		addAppFile: 'http-root\fckeditor\editor\plugins\placeholder\placeholder.gif';
		addAppFile: 'http-root\fckeditor\editor\plugins\placeholder\lang\de.js';
		addAppFile: 'http-root\fckeditor\editor\plugins\placeholder\lang\en.js';
		addAppFile: 'http-root\fckeditor\editor\plugins\placeholder\lang\fr.js';
		addAppFile: 'http-root\fckeditor\editor\plugins\placeholder\lang\it.js';
		addAppFile: 'http-root\fckeditor\editor\plugins\placeholder\lang\pl.js';
		addAppFile: 'http-root\fckeditor\editor\plugins\simplecommands\fckplugin.js';
		addAppFile: 'http-root\fckeditor\editor\plugins\tablecommands\fckplugin.js';
		addAppFile: 'http-root\fckeditor\editor\skins\_fckviewstrips.html';
		addAppFile: 'http-root\fckeditor\editor\skins\default\fck_dialog.css';
		addAppFile: 'http-root\fckeditor\editor\skins\default\fck_editor.css';
		addAppFile: 'http-root\fckeditor\editor\skins\default\fck_strip.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\default\images\toolbar.arrowright.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\default\images\toolbar.buttonarrow.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\default\images\toolbar.collapse.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\default\images\toolbar.end.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\default\images\toolbar.expand.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\default\images\toolbar.separator.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\default\images\toolbar.start.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\office2003\fck_dialog.css';
		addAppFile: 'http-root\fckeditor\editor\skins\office2003\fck_editor.css';
		addAppFile: 'http-root\fckeditor\editor\skins\office2003\fck_strip.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\office2003\images\toolbar.arrowright.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\office2003\images\toolbar.bg.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\office2003\images\toolbar.buttonarrow.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\office2003\images\toolbar.collapse.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\office2003\images\toolbar.end.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\office2003\images\toolbar.expand.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\office2003\images\toolbar.separator.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\office2003\images\toolbar.start.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\silver\fck_dialog.css';
		addAppFile: 'http-root\fckeditor\editor\skins\silver\fck_editor.css';
		addAppFile: 'http-root\fckeditor\editor\skins\silver\fck_strip.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\silver\images\toolbar.arrowright.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\silver\images\toolbar.buttonarrow.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\silver\images\toolbar.buttonbg.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\silver\images\toolbar.collapse.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\silver\images\toolbar.end.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\silver\images\toolbar.expand.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\silver\images\toolbar.separator.gif';
		addAppFile: 'http-root\fckeditor\editor\skins\silver\images\toolbar.start.gif'!

addImageFiles
	self
		addImageFile: 'bt-changeLog.gif';
		addImageFile: 'book2.gif';
		addImageFile: 'book1.gif';
		addImageFile: 'bt-copy.gif';
		addImageFile: 'bt-createNew.gif';
		addImageFile: 'bt-edit.gif';
		addImageFile: 'bt-goBack.gif';
		addImageFile: 'bt-lucka.gif';
		addImageFile: 'bt-nextObject.gif';
		addImageFile: 'bt-previousObject.gif';
		addImageFile: 'bt-remove.gif';
		addImageFile: 'bt-search.gif';
		addImageFile: 'checkbox.gif';
		addImageFile: 'download.gif';
		addImageFile: 'ideja-lucka.gif';
		addImageFile: 'page1.gif';
		addImageFile: 'page2.gif';
		addImageFile: 'page3.gif';
		addImageFile: 'pixel.gif';
		addImageFile: 'print-page.gif';
		addImageFile: 'ServMgmt.gif';
		addImageFile: 'UserMgmt.gif';
		addImageFile: 'warning2.gif';
		addImageFile: 'diskette3.gif';
		addImageFile: 'external.gif';
		addImageFile: 'external.png';
		addImageFile: 'koledar.gif';
		addImageFile: 'koledarClose.gif'!

addJavascriptFiles

	"for Plotr"
	self
		addHttpRootFile: 'scripts\prototype.js';
		addHttpRootFile: 'scripts\excanvas.js';
		addHttpRootFile: 'scripts\plotr.js'!

applicationPath
	^'WikiDoc'!

applicationVersion
	^WikiDocApplication new currentReleaseId asWebString!

defaultApplication
	^WikiDocApplication default!

executableName
	^'WikiDoc.exe'!

generateInnoSetupScriptAfterFilesAndDirectoriesOn: ws 
	ws 
		nextPutAll: '
[Setup]

AppCopyright=© 2004-' , Date today year printString 
				, ' IT consulting Gorisek d.o.o. http://www.gorisek.com
AppName=WikiDoc
AppVerName=WikiDoc ' 
					, self defaultApplication currentReleaseId 
					, '
PrivilegesRequired=poweruser
DefaultDirName={pf}\WikiDoc
AppPublisher=IT consulting Gorisek d.o.o.
AppPublisherURL=http://wiki.gorisek.com
AppSupportURL=http://wiki.gorisek.com
UninstallDisplayIcon={app}\' 
					, self executableName 
					, '
DefaultGroupName=WikiDoc
;MessagesFile=English.isl
LicenseFile=distro\WikiDoc License.rtf
OutputBaseFilename=WikiDocSetup_' 
					, self defaultApplication currentReleaseId 
					, '

[Tasks]
Name: desktopicon; Description: Create a &desktop icon; GroupDescription: Additional icons:

[Icons]
Name: {group}\WikiDoc; Filename: {app}\' 
					, self executableName 
					, '; WorkingDir: {app}; IconIndex: 0
Name: {group}\WikiDoc license; Filename: {app}\License.rtf
Name: {group}\WikiDoc configuration; Filename: {app}\WikiDoc.cfg
Name: {group}\Uninstall WikiDoc; Filename: {uninstallexe}
Name: {userdesktop}\Start WikiDoc server; Filename: {app}\' 
					, self executableName 
					, '; Tasks: desktopicon; WorkingDir: {app}; IconIndex: 0

[Run]
Filename: {app}\' 
					, self executableName 
					, '; Description: Run WikiDoc; Flags: nowait postinstall skipifsilent; WorkingDir: {app}
'! !
!WikiDocInstaller categoriesFor: #addAllInstallerFiles!compile installation!public! !
!WikiDocInstaller categoriesFor: #addAllInstallerFilesForFirstInstallation!public! !
!WikiDocInstaller categoriesFor: #addCssAndJavascriptDirectories!public! !
!WikiDocInstaller categoriesFor: #addDirectories!public! !
!WikiDocInstaller categoriesFor: #addDirectoriesAndFilesForFCKEditors!public! !
!WikiDocInstaller categoriesFor: #addImageFiles!compile installation!images!public! !
!WikiDocInstaller categoriesFor: #addJavascriptFiles!public! !
!WikiDocInstaller categoriesFor: #applicationPath!public! !
!WikiDocInstaller categoriesFor: #applicationVersion!public! !
!WikiDocInstaller categoriesFor: #defaultApplication!images!public! !
!WikiDocInstaller categoriesFor: #executableName!images!public! !
!WikiDocInstaller categoriesFor: #generateInnoSetupScriptAfterFilesAndDirectoriesOn:!private! !

