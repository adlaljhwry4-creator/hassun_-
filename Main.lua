print("Loading...")

for i = 1, 100 do
    print("Loading "..i.."%")
    task.wait(0.05)
end

print("Finished!")