Config = {}

Config.Setting = {
	KPV 		= 'STATUSAR',			-- เปลี่ยนเป็นอะไรก็ได้ให้ไม่ซ้ำกับเซิฟอื่น
	TickTime 	= 1000, 				-- อัตราการเผาพลาญพลังงาน (วินาที)
	TickUpdate 	= 10000 				-- ระยะเวลาการอัพเดตค่าสถานะ
}

Config.Status = { -- สถานะที่ต้องการ (กำหนดได้ไม่จำกัด)
    -- max คือ ค่าสูงสุดของสถานะนั้นๆ (ระบบจะคำนวนเป็น % ให้อัตโนมัติ)
    -- del คือ ค่าที่ต้องการเผาพลาญต่อวินาที (อ้างอิงจาก Config.TickTime)
    ['hunger'] = { 
        max = 1000000,
        del = {
            [1] = 1500,
            [2] = 550,
            [3] = 400
        } 
    },
    ['stress'] = { 
        max = 1000000,
        del = {
            [1] = 400,
            [2] = 275,
            [3] = 200
        }
    }
}
--[[
    ### ดึงข้อมูลค่าสถานะทั้งหมด ###
    exports.ar_status:onStatus() // ระบบจำคำนวนเป็น % ให้แล้ว

	-- true หยุดใช้งาน status
	-- false เปิดใช้งาน status
	exports.ar_status:ToggleStatus(bool)

    ### จัดการสถานะ ###
    - type คือ ชื่อของสถานะ เช่น hunger , stress เป็นต้น
    - action มี 3 อย่างคือ add = เพิ่ม , remove = ลบ , set = แทนค่า
    - value คือ จำนวนที่ต้องการทำ action
    exports.ar_status:OnAction(type, action, value)
]]