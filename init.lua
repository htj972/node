wifi.setmode(wifi.STATION) 

gpio.mode(1,gpio.INPUT) 
if gpio.read(1)==0 then
wifi.startsmart(0,
   function(ssid, password)
        print(string.format("Success. SSID:%s ; PASSWORD:%s",ssid,password))
        wifi.sta.config(ssid,password)
        file.open("ssid.lua", "w+")
        file.write(ssid)
        file.close()
        
        file.open("password.lua", "w+")
        file.write(password)
        file.close() 
    end
)
end

if gpio.read(1)==1 then
	file.open("ssid.lua", "r")
	aid = file.readline()
	print(aid)
	file.close()
	
	file.open("password.lua", "r")
	amima = file.readline()
	print(amima)
	file.close()

	wifi.sta.config(aid,amima)
end
wifi.sta.autoconnect(1)

--

tmr.alarm(1, 1000, 1, function()

--

if wifi.sta.getip()== nil then

print("IP unavaiable, Waiting...")

--

else

tmr.stop(1)

print("IP is "..wifi.sta.getip().. " Port is:80".."/nstart listen")

sv=net.createServer(net.TCP)

sv:listen(80,function(c)

--

c:on("receive", function(sck, result) 

--
G = 6
R = 5
B = 2
--

if  (result ~= "on") and (result ~= "off" ) then

pwm.setup(R, 1000, tonumber( result)/100000000)
pwm.setup(G, 1000,tonumber( result)%100000000/10000)
pwm.setup(B, 1000,tonumber( result)%10000)
pwm.start(G)
pwm.start(R)
pwm.start(B)
c:send("led :"..result)
end
--
if  result=="on" then
gpio.mode(R,gpio.OUTPUT) 
gpio.mode(G,gpio.OUTPUT) 
gpio.mode(B,gpio.OUTPUT) 
gpio.write(R,gpio.LOW) 
gpio.write(G,gpio.LOW)
gpio.write(B,gpio.LOW)
c:send("led :on")
end

--

if result=="off" then

gpio.mode(R,gpio.OUTPUT) 
gpio.mode(G,gpio.OUTPUT) 
gpio.mode(B,gpio.OUTPUT) 
gpio.write(R,gpio.HIGH) 
gpio.write(G,gpio.HIGH)
gpio.write(B,gpio.HIGH)
c:send("led :off")
end
--
print(result)
--if result=="close" then
--c:close()
--sv:close()
--print("TCP Close")
--end 

end)

end)

end

end)
