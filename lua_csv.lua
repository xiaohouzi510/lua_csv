local fun,file_name,count = ...
print(fun,file_name,count)
function split(s, symbol)
    local len = #symbol
    local t = {}
    local i = string.find(s, symbol)
    local j = 1
    while i do
        table.insert(t, string.sub(s, j, i-1))
        j = i + len
        i = string.find(s, symbol, j)
    end
    table.insert(t, string.sub(s, j, #s))
    return t
end

function read_csv(file_name)
	local file = io.open(file_name,"r")
	if not file then
		print("read_csv open file error")
		return
	end
	local data = {}
	for line in file:lines() do
		table.insert(data,split(line,","))
	end

	return data
end

function write_csv(data,file_name)
	local file = io.open(file_name,"w+")
	if not file then
		print("write_csv open file error")
		return
	end
	for _,v in pairs(data) do
		local len = #v
		if len ~= 0 then
			for i=1,len do
				file:write(v[i])
				if i ~= len then
					file:write(",")
				end
			end
			file:write("\n")
		end
	end
end

function p(t)
	for k,v in pairs(t) do
		local str = ""
		for k1,v1 in pairs(v) do
			str = str.." "..v1
		end
		print(str)
	end
end

function table_by_colum(src_data,target_data,colum)
	for k,v in pairs(src_data) do
		local id = v[colum]
		target_data[id] = target_data[id] or {}
		table.insert(target_data[id],v)
	end
end

local all_alter_data = {}
function read_all_csv()
	for i=1,20 do
		local data = read_csv(file_name..i..".csv")
		assert(data)
		table_by_colum(data,all_alter_data,2)
	end
end

function pt(t)
	local str = ""
	local key = nil
	for k,v in pairs(t) do
		if not key then
			key = v
		end
		if type(v) == "table" then
			pt(v)
		else
			str = str.." "..v
		end
	end
	print(key,str)
end

function one()
	local result_data = {}
	local all_src_data = {}
	local data = read_csv("充值.csv")
	table_by_colum(data,all_src_data,2)
	read_all_csv()

	for k,v in pairs(all_src_data) do
		local value = all_alter_data[k]
		if value then
			for k2,v2 in pairs(value) do
				table.insert(result_data,v2)
			end
		end
	end

	write_csv(result_data,file_name.."_result.csv")
end

function union_csv(name,count)
	local all_data = {}
	for i=1,count do
		local data = read_csv(name..i..".csv")
		assert(data)
		for _,v in pairs(data) do
			table.insert(all_data,v)
		end
	end

	write_csv(all_data,name.."_result.csv")
end

local funs = {union_csv=union_csv}

if "union_csv" == fun then
	union_csv(file_name,count)
end