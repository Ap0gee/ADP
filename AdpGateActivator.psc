Scriptname AdpGateActivator extends AdpActivator

;-----------------------------------------------------------------------------@[props]




;-----------------------------------------------------------------------------@[methods]

Function  timedActivationBlock(Float seconds)
	self.BlockActivation(True)
	Form  activatorForm =  self.GetBaseObject()
	String previousName = activatorForm.GetName()
	activatorForm .SetName("")
	utility.wait(seconds)
	activatorForm.SetName(previousName)
	self.BlockActivation(False)
endFunction

;-----------------------------------------------------------------------------@[events]



;-----------------------------------------------------------------------------@[states]
