local SaltPond = Class(function(self, inst)
    self.inst = inst
    self.numsalt = 0
    self.maxsalt = 1
    self.saltprefab = nil
    self.saltextractor = nil
    -- self.basetime = 150
    -- self.basetime = 60
    self.basetime = 150
    -- self.timeinc = 10
    self.timeinc = 10
end)

function SaltPond:SetUp(saltprefab, numsalt)
    self.saltprefab = saltprefab
    self.numsalt = numsalt
    self.maxsalt = numsalt
end

function SaltPond:GetExtractTime()
    return self.basetime
end

function SaltPond:IsDepleted()
    return self.numsalt <= 0
end

function SaltPond:Install(saltextractor)
    self.saltextractor = saltextractor
end

function SaltPond:Deduct()
    self.numsalt = self.numsalt - 1
end

function SaltPond:OnSave()
    local data =
    {
        numsalt = self.numsalt,
        maxsalt = self.maxsalt,
        saltprefab = self.saltprefab,
        -- saltextractor = self.saltextractor:GetSaveRecord(),
    }
    return data
end


function SaltPond:Onload(data)
if self.numsalt == self.maxsalt then
            inst.extractor.AnimState:Show("salt")
        end
    end

return SaltPond
