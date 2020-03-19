"
I analyse the memory consumption (and other metrics) of various FamixModels

Creation:
  analyst := FMUAnalyst new models: aCollectionOfFamixModels

Analysis (will return a string in CSV format importable by spreadsheets):
  analyst allMetricsAsCSV
"
Class {
	#name : #FMUAnalyst,
	#superclass : #Object,
	#instVars : [
		'models'
	],
	#category : #FamixMemoryUsage
}

{ #category : #api }
FMUAnalyst >> allMetrics [
	^#(nbEntities totalMemory)
]

{ #category : #api }
FMUAnalyst >> allMetricsAsCSV [
	^self metricsAsCSV: self allMetrics
]

{ #category : #api }
FMUAnalyst >> metricsAsCSV: metrics [
	^String streamContents: [:str |
		(NeoCSVWriter on: str)
			fieldWriter: #optionalQuoted ;
			lineEndConvention: #cr ;
			nextPut: #('model') , metrics ;
			addFields: #(modelName) , metrics ;
			nextPutAll: models.
		str
	]
]

{ #category : #accessing }
FMUAnalyst >> models: aCollection [ 
	models := aCollection collect: [ :m | FMUModelAnalysis new on: m ]
]

{ #category : #metrics }
FMUAnalyst >> nbEntities [
	^ models collect: #nbEntities
]

{ #category : #metrics }
FMUAnalyst >> totalMemory [
	^ models collect: #totalMemory
]
