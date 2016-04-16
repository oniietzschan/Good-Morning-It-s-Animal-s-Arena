local TemplateParser = {}

function TemplateParser:mirror(template)
    local mirrored = util.deepcopy(template)
    for i = 1, #mirrored do
        mirrored[i] = mirrored[i]:reverse()
    end

    return mirrored
end

function TemplateParser:parse(template, func)
    for y = 0, #template - 1 do
        for x = 0, #template[y + 1] - 1 do
            local char = template[y + 1]:sub(x + 1, x + 1)

            local ret = func(char, x, y)

            if ret ~= nil then
                return ret
            end
        end
    end
end

return TemplateParser
