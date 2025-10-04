Extension { #name : 'TestResult' }

{ #category : '*AI-Pharo-Copilot-Tests' }
TestResult >> dispatchResultsIntoHistory [

	self classesTested do:
		[ :testClass |
		self class
			historyAt: testClass
			put: (self selectResultsForTestCase: testClass) ]
]
