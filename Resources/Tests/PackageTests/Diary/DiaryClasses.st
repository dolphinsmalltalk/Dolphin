Object subclass: #DiaryEvent
	instanceVariableNames: 'description triggerTime '
	classVariableNames: ''
	poolDictionaries: ''!

Object subclass: #Diary
	instanceVariableNames: 'diaryEvents monitorProcess mutex '
	classVariableNames: ''
	poolDictionaries: ''!

Tool subclass: #DiaryTool
	instanceVariableNames: 'diary filteredDiaryEventsModel '
	classVariableNames: ''
	poolDictionaries: ''!

Tool subclass: #DiaryEventEditor
	instanceVariableNames: 'diaryEventModel '
	classVariableNames: ''
	poolDictionaries: ''!

