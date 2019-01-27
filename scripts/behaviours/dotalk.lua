
DoTalk = Class(BehaviourNode, function(self, inst)
    BehaviourNode._ctor(self, "DoTalk")
    self.inst = inst
end)


function DoTalk:Visit()

    if self.status == READY then
        self.status = RUNNING
        self.inst.components.locomotor:Stop()
        self.inst.sg:GoToState("talk")
    end

    if self.status == RUNNING then
        if not self.inst.sg:HasStateTag("talk") then
            self.status = FAILED
        end
    end

end
