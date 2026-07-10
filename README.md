-- السكربت يرسل أوامر للسيرفر
game:GetService("ReplicatedStorage"):WaitForChild("BuyPet"):FireServer(pet)
-- لكن بدل ما تروح لحسابك، تروح لحساب السارق! 
-- السكربت يستخرج معلومات الحيوانات الأليفة
local pets = game:GetService("dsdogs1312").LocalPlayer:WaitForChild("PetSimulator"):WaitForChild("Pets")
-- ثم يرسلها للسيرفر التابع للسارق 
