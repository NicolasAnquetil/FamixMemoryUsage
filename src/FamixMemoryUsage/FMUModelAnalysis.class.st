"
I analyse the memory consumption (and other metrics) of a FamixModel. I am create and used by FMUAnalyst

Creation:
	modelAnalyst := FMUModelAnalysis new on: aFamixModel

API methods:
- totalMemory : returns the total memory used by entities in my model
- dumpTallyAsCSV : dumps tally values (see SpaceTallyItem) for all class of entities in the model
"
Class {
	#name : #FMUModelAnalysis,
	#superclass : #Object,
	#instVars : [
		'model',
		'tally',
		'classes'
	],
	#category : #FamixMemoryUsage
}

{ #category : #api }
FMUModelAnalysis >> dumpTallyAsCSV [
	| cols |
	cols := #(analyzedClassName codeSize instanceCount spaceForInstances).
	^String streamContents: [:str |
		(NeoCSVWriter on: str)
			fieldWriter: #optionalQuoted ;
			lineEndConvention: #cr ;
			nextPut: { self modelName } , cols allButFirst ;
			addFields: cols ;
			nextPutAll: (tally sorted: [:a :b | a analyzedClassName < b analyzedClassName]).
		str
	]
]

{ #category : #accessing }
FMUModelAnalysis >> modelName [
	^ model name
]

{ #category : #metrics }
FMUModelAnalysis >> nbEntities [
	^model entities size
]

{ #category : #'instance creation' }
FMUModelAnalysis >> on: aFamixModel [ 
	model := aFamixModel.
	classes := model entities collectAsSet: #class.
	tally := SpaceTally new spaceTally: classes
]

{ #category : #metrics }
FMUModelAnalysis >> totalMemory [
	^(tally collect: #spaceForInstances) sum
]
