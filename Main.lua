print("Loading...")

for i = 1, 100 do
    print("Loading "..i.."%")
    task.wait(0.05)
end

print("Finished!")
local gui = script.Parent
local background = gui.Background

local text = background.LoadingText
local bar = background.LoadingBar.Progress

for i = 1,100 do
    text.Text = "Loading... "..i.."%"

    bar.Size = UDim2.new(i/100,0,1,0)

    task.wait(0.03)
end

text.Text = "Finished!"

task.wait(1)

gui.Enabled = false