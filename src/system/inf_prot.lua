local InfProt = class('InfProt')

function InfProt:initialize(limit)
    self.limit = limit or 1000
    self.count = 0
end

function InfProt:inc(debug)
    self.count = self.count + 1
    if self.count >= self.limit then
        var_dump(debug)

        error('Infinite loop encountered!', 2)
    end
end

return InfProt
