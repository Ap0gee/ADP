Scriptname AdpCutSceneCreator extends AdpSingleObjectTranslator  

import AdpUtils
import utility
import debug

ImageSpaceModifier Property FadeTo Auto Hidden
ImageSpaceModifier Property FadeFrom Auto Hidden
Bool Property InCutScene = False Auto Hidden
Int  Property SkipHotKey  =28 Auto Hidden
Bool  Property HidePlayer = True Auto
Actor Property AdpCameraRef Auto Hidden
Int  Property AdpCameraFormID  = 0x0010D13E Auto Hidden
Float  Property ActorHomeX Auto Hidden
Float  Property ActorHomeY Auto Hidden
Float  Property ActorHomeZ Auto Hidden
Float  Property ActorHomeAX Auto Hidden
Float  Property ActorHomeAY Auto Hidden
Float  Property ActorHomeAZ Auto Hidden

String Function getTranslatedRefType()
	return "AdpCutSceneCreator"
endFunction

Function fadeOut(float time)
	FadeTo.Apply()
	delay(time)
	Game.FadeOutGame(False,True,50, 1)
endFunction

Function fadeIn(float time)
	delay(time)
	Game.FadeOutGame(False,True,0.1, 0.1)
	FadeTo.PopTo(FadeFrom)
endFunction

Function setActorVisibility(Actor actorRef, Bool visible = True)
	Float alpha = 1.0
	Bool ghost = False
	IF ! visible
		alpha = 0.0
		ghost = True
	ENDIF	
	actorRef.SetAlpha(alpha)
	actorRef.SetGhost(ghost)
endFunction

Actor Function getCameraRef()
	Actor cameraRef = self.PlaceAtMe(Game.GetForm(self.AdpCameraFormID)) as Actor
	return cameraRef 
endFunction
	
Function setCameraRef()
	IF ! self.ObjectRef
		self.AdpCameraRef = self.getCameraRef()
		self.ObjectRef = self.AdpCameraRef as ObjectReference
	ELSE	
		self.AdpCameraRef = ObjectRef as Actor
	ENDIF	
endFunction

Function setupActorCamera(Actor actorRef )
	Game.SetCameraTarget(actorRef)
	Game.ForceThirdPerson()
	Game.ForceFirstPerson()
endFunction	

Function moveActorToFirstMarker(Actor actorRef)
	actorRef.SetPosition(self.NextMarker.X, self.NextMarker.Y, self.NextMarker.Z)
	actorRef.SetAngle(self.NextMarker.GetAngleX(), self.NextMarker.GetAngleY(), self.NextMarker.GetAngleZ())
endFunction

Function moveActorHome(Actor actorRef)
	actorRef.SetPosition(self.ActorHomeX, self.ActorHomeY, self.ActorHomeZ)
	actorRef.SetAngle(self.ActorHomeAX, self.ActorHomeAY, self.ActorHomeAZ)
endFunction

Function setActorHome(Actor actorRef)
	self.ActorHomeX  = actorRef.X
	self.ActorHomeY  = actorRef.Y
	self.ActorHomeZ  = actorRef.Z
	self.ActorHomeAX   = actorRef.GetAngleX()
	self.ActorHomeAY  = actorRef.GetAngleY()
	self.ActorHomeAZ = actorRef.GetAngleZ()
endFunction	

Function startCutScene(Bool fadeOut=True, Float fadeOutTime=1.0)
	self.InCutScene = True
	Game.DisablePlayerControls(True, True,True, True, True,True, True, True)
	Game.GetPlayer().StopCombat()
	debug.SetGodMode(True)
	IF fadeOut
		self.fadeOut(fadeOutTime)
	ENDIF
	self.AdpCameraRef.SetMotionType(Motion_Keyframed)
	self.AdpCameraRef.SetScale(1.0)
	SetIniFloat("fMouseWheelZoomSpeed:Camera", 0.0)
	SetIniBool("bDisablePlayerCollision:Havok", True)
	debug.ToggleCollisions()
	debug.ToggleAI()
	self.setRefEnabledState(self.AdpCameraRef, True, False)
	self.setActorVisibility(self.AdpCameraRef, False)
	IF self.HidePlayer
		self.setActorVisibility(Game.GetPlayer(), False)
	ENDIF	
	self.setActorHome(self.AdpCameraRef)
	self.moveActorToFirstMarker(self.AdpCameraRef)
	self.setupActorCamera(self.AdpCameraRef)
	self.fadeIn(1.0)
	RegisterForSingleUpdate(0.25)
endFunction

Function endCutScene(Bool fadeOut=True, Float fadeOutTime=1.0)
	self.InCutScene = False
	IF fadeOut
		self.fadeOut(fadeOutTime)
	ENDIF
	self.AdpCameraRef.StopTranslation()
	SetIniFloat("fMouseWheelZoomSpeed:Camera", 10.0)
	SetIniBool("bDisablePlayerCollision:Havok", False)
	self.moveActorHome(self.AdpCameraRef)
	self.setRefEnabledState(self.AdpCameraRef, False, False)
	debug.ToggleCollisions()
	debug.ToggleAI()
	self.setupActorCamera(Game.GetPlayer())
	IF self.HidePlayer
		self.setActorVisibility(Game.GetPlayer(), True)
	ENDIF	
	Game.EnablePlayerControls()
	debug.SetGodMode(False)
	self.fadeIn(1.0)
	GoToState("waiting")
endFunction 	

Event onLoad()
	parent.onLoad()
	self.ControllerRef = self as AdpTranslatedReference
	self.setCameraRef()
	self.setRefEnabledState(self.AdpCameraRef, False, False)
endEvent

Event onUpdate()
	IF self.InCutScene
		debug.Notification("Hold Enter To Skip")
		IF Input.IsKeyPressed(self.SkipHotKey)
			self.abortTranslation()
			self.endCutScene()
		ENDIF	
		RegisterForSingleUpdate(0.25)
	ENDIF
endEvent	

auto State waiting
	Event onBeginState()
	endEvent
	Event onActivate (ObjectReference triggerRef)
		self.enableTranslation()
		self.startCutScene()
		GoToState("busy")
	endEvent	
endState

State busy
	Event onBeginState()
		IF self.NextMarker && self.ObjectRef
			self.NextMarker.ObjectRef = self.ObjectRef
			IF self.ShareProperties
				self.setNextMarkerProps()
			ENDIF
			self.CurrentMarker = self.NextMarker
			self.NextMarker.onTranslationComplete()
		ENDIF
	endEvent
	Event onActivate (ObjectReference triggerRef)
		self.endCutScene()
	endEvent	
endState