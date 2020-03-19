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
		'tally',
		'famixModel'
	],
	#category : #FamixMemoryUsage
}

{ #category : #'instance creation' }
FMUModelAnalysis class >> on: aModel [
	^self new on: aModel ; yourself
]

{ #category : #api }
FMUModelAnalysis >> dumpTallyAsCSV [
	| cols |
	cols := #(className instanceCount instanceSize totalMemory).
	^String streamContents: [:str |
		(NeoCSVWriter on: str)
			fieldWriter: #optionalQuoted ;
			lineEndConvention: #cr ;
			nextPut: { self modelName } , cols allButFirst ;
			addFields: cols ;
			nextPutAll: (tally sorted: [:a :b | a className < b className]).
		str
	]
]

{ #category : #accessing }
FMUModelAnalysis >> modelName [
	^ famixModel name
]

{ #category : #metrics }
FMUModelAnalysis >> nbEntities [
	^famixModel entities size
]

{ #category : #'instance creation' }
FMUModelAnalysis >> on: aFamixModel [ 
	famixModel := aFamixModel.
	tally := (famixModel entities collectAsSet: #class) collect: [:c | FMUClassTally on: c inModel: famixModel ].
	
]

{ #category : #metrics }
FMUModelAnalysis >> totalMemory [
	^(tally collect: #totalMemory) sum
]
