"
I analyse the memory consumption (and other metrics) of a FamixModel. I am create and used by FMUAnalyst

Creation:
	modelAnalyst := FMUModelAnalysis new on: aFamixModel

Computing metrics (returns the total memory used by entities in my model):
	modelAnalyst totalMemory
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
