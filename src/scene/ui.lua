local Ui = class('Ui', Scene)

function Ui:initialize(t)
    t = t or {}

    Scene.initialize(self, t)

    self:initFonts()

    self.dialog_opened = false
    self.dialog_speed = t.speed or 50

    -- Status Display
    self.ui_x = 5
    self.ui_y = 5

    -- Dialog Window
    self.dialog_font = font["dialog"]
    self.dialog_lines = 3
    self.dialog_x = 10
    self.dialog_y = 198
    self.dialog_w = 300
    self.dialog_h = 32
    self.dialog_pad = 2
    self.dialog_alpha_text = 255
    self.dialog_alpha_bg = 150
end

function Ui:initFonts()
    font = {}

    font['font'] = lg.newImageFont(
        'assets/font.png',
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 :-!.,"?',
        1
    )
    font['font']:setLineHeight(1)

    lg.setFont(font['font'])
    lg.setLineWidth(1)

    -- font["mono16"] = lg.newImageFont(
    --     'assets/fonts/jasoco_mono16.png',
    --     "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 :-!.,\"?>_"
    -- )
    -- font["mono16"]:setLineHeight(1)

    -- font["dialog"] = lg.newImageFont(
    --     'assets/fonts/jasoco_dialog.png',
    --     " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`_*#=[]'{}"
    -- )
    -- font["dialog"]:setLineHeight(.6)

    -- font["tiny"] = lg.newImageFont(
    --     'assets/fonts/jasoco_tiny.png',
    --     " 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.-,!:()[]{}<>"
    -- )
    -- font["tiny"]:setLineHeight(.8)
end

function Ui:displayGameOver()
end

function Ui:draw()
    self:drawFps()

    if not game.isGameOver then
        self:drawPlayerStatus()
        self:drawScore()
        self:drawCrosshair()
    else
        self:drawGameOver()
    end

    -- self:drawDialog()
    -- self:drawDialogDebug()
end

function Ui:drawFps()
    self:drawTextWithShadow("FPS: " .. tostring(love.timer.getFPS()), 200, -1)
end

function Ui:drawPlayerStatus()
    if player == nil then
        return
    end

    self:drawPlayerFormName()
    self:drawPlayerHp()
end

function Ui:drawPlayerFormName()
    self:drawTextWithShadow(player.form, -1, -1)
end

function Ui:drawPlayerHp()
    if player.hp <= 1 then
        return
    end
    self:drawTextWithShadow(player.hp, -1, 10)
end

function Ui:drawScore()
    self:drawTextWithShadow(string.format("%06d", game.score), 583, -1)
end

function Ui:drawCrosshair()
    lg.setColor(COLOR_QT)
    local x, y = Util:mousePos()
    lg.draw(img.crosshair.image, x - 6, y - 6)
end

function Ui:drawGameOver()
    local texts = {
        {'GAME OVER'},
        {''},
        {"YOUR SCORE: " .. string.format("%06d", game.score)},
        {"HIGH SCORE: " .. string.format("%06d", game.highScore), 3},
        {''},
        {'PRESS "R" TO RESTART'},
    }
    for i, t in ipairs(texts) do
        local text, offsetX = unpack(t)
        offsetX = offsetX or 0
        self:drawTextWithShadow(text, 200 + offsetX, (12 * i) + 50)
    end
end

function Ui:drawTextWithShadow(text, x, y)
    self:drawText(text, self.ui_x + x + 1, y + self.ui_y + 1, COLOR_UI_SHADOW)
    self:drawText(text, self.ui_x + x,     y + self.ui_y,     COLOR_WHITE)
end

function Ui:drawText(text, x, y, color)
    lg.setColor(color)
    lg.print(text, x, y)
end

-- function Ui:pushMessage(t)
--     self.dialog_message_full = t.msg or ''
--     self.dialog_message = self.dialog_message_full

--     self.dialog_opened = true
--     self.dialog_length = 0
--     self:determineLastWordEndPosition()
-- end

-- function Ui:update(dt)
--     self:updateDialog(dt)
-- end

-- function Ui:updateDialog(dt)
--     if not self.dialog_opened then
--         return
--     end

--     self:handleDialogInput()
--     self:advanceDialog(dt)
-- end

-- function Ui:handleDialogInput()
--     if input:pressed('confirm') and self.dialog_length > 0 then
--         if (self:isDialogFullyAdvanced()) then -- Already Finished Advancing: Proceed to next message
--             self.dialog_message = self.dialog_message:sub(self.dialog_length + 1)
--             self.dialog_length = 0

--             if #self.dialog_message > 0 then -- More text to be displayed.
--                 self:determineLastWordEndPosition()
--             else -- Dialog finished
--                 self.dialog_opened = false
--             end
--         else -- Still Advancing: Advance current message to the end.
--             self.dialog_length = self.last_word_end_pos
--         end
--     end
-- end

-- function Ui:isDialogFullyAdvanced()
--     return (self.dialog_length >= self.last_word_end_pos)
-- end

-- function Ui:advanceDialog(dt)
--     self.dialog_length = self.dialog_length + self.dialog_speed * dt

--     if self.dialog_length > self.last_word_end_pos then
--         self.dialog_length = self.last_word_end_pos
--     end
-- end

-- function Ui:determineLastWordEndPosition()
--     local pos = 0

--     for i=1, #self.dialog_message do
--         local character = self.dialog_message:sub(i,i)
--         local msg = self.dialog_message:sub(1, math.floor(i))

--         if character == ' ' then
--             pos = i - 1 -- last character was the end of a word
--         end

--         if self:getLineCount(msg) > self.dialog_lines then
--             self.last_word_end_pos = pos
--             return
--         end
--     end

--     self.last_word_end_pos = #self.dialog_message
-- end

-- function Ui:drawDialog()
--     if not self.dialog_opened then
--         return
--     end

--     lg.setColor(255, 255, 255, self.dialog_alpha_bg)
--     lg.rectangle('fill', self.dialog_x, self.dialog_y, self.dialog_w, self.dialog_h)

--     lg.setFont(self.dialog_font)
--     lg.setColor(0, 0, 0, self.dialog_alpha_text)
--     lg.printf(
--         self:getDialogDisplayString(), self.dialog_x + self.dialog_pad, self.dialog_y + self.dialog_pad, self.dialog_w - self.dialog_pad*2
--     )
-- end

-- -- Optimize: this is being called several times per character
-- function Ui:getDialogDisplayString()
--     local pos          = math.floor(self.dialog_length)
--     local pos_word_end = self.dialog_message:find(' ', pos)
--     local msg          = self.dialog_message:sub(1, pos)
--     local msg_word_end = self.dialog_message:sub(1, pos_word_end)
--     local lines          = self:getLineCount(msg)
--     local lines_word_end = self:getLineCount(msg_word_end)

--     -- If current word will be on the next line when it is fully displayed, add it's newline now.
--     if (lines ~= 0 and lines ~= lines_word_end) then
--         local word_start = string.find(msg, "%s[^%s]*$")
--         msg = msg:sub(0, word_start) .. "\n" .. msg:sub(word_start)
--     end

--     return msg
-- end

-- function Ui:getLineCount(msg)
--     local real_width, lines = self.dialog_font:getWrap(msg, self.dialog_w - self.dialog_pad * 2)

--     return lines
-- end

-- function Ui:drawDialogDebug()
--     lg.setFont(font['font'])
--     lg.setColor(COLOR_QT)
--     local real_width, lines = self.dialog_font:getWrap(msg, w)
--     local suf = ''
--     if (self:isDialogFullyAdvanced()) then suf = ' READY' end
--     lg.print("WRAP: " .. lines .. suf, 2, 18)
-- end

-- -- UNUSED SO FAR
-- function Ui:drawBar(text, cur, max, x, y, inner_color)
--     -- Bar
--     lg.setColor(COLOR_BLACK) -- Black Background
--     lg.rectangle('fill', x, y, self._ui_bar_w, self._ui_bar_h)
--     lg.setColor(inner_color) -- Red Filled Area
--     lg.rectangle('fill', x, y, math.floor(self._ui_bar_w * (cur / max)), self._ui_bar_h)
--     lg.setColor(COLOR_WHITE) -- White Outline
--     lg.rectangle('line', x + 0.5, y + 0.5, self._ui_bar_w, self._ui_bar_h - 1)

--     -- Text
--     lg.setColor(COLOR_BLACK)
--     lg.print(text .. cur, x + 3, y + 3)
--     lg.setColor(COLOR_WHITE)
--     lg.print(text .. cur, x + 2, y + 2)
-- end

return Ui

-- 'Once detachment, viveka, is interpreted mainly in this internal sense, it appears perhaps easier to achieve it today than in a more normal and traditional civilization. One who is still an "Aryan" spirit in a large European or American city, with its skyscrapers and asphalt, with its politics and sport, with its crowds who dance and shout, with its exponents of secular culture and of soulless science and so on - among all this he may feel himself more alone and detached and nomad than he would have done in the time of the Buddha, in conditions of physical isolation and of actual wandering.'
