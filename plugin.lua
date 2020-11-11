function draw()
  imgui.Begin("QR Inflator")


  local offsetFactor = get("offset", 9)
  _, offsetFactor = imgui.InputInt("4K Offset", offsetFactor)
  state.SetValue("offset", offsetFactor)

  local button = imgui.Button("Inflate")
  
  if button then
    objectlist = {}
    laneoffset = {}
    for i, v in ipairs(map.HitObjects) do
      -- v.StartTime = v.StartTime + v.Lane * 10 - map.GetKeyCount() / 2
      -- if v.EndTime > 0 then
      --   v.EndTime = v.EndTime + v.Lane * 10 - map.GetKeyCount() / 2
      -- end
      local offset = 0
      if map.GetKeyCount() == 7 then 
        offset = v.Lane - map.GetKeyCount() / 2
      else
        if (laneoffset[v.Lane + 1] != 1) then
          laneoffset[v.Lane + 1] = 1
        else
          laneoffset[v.Lane + 1] = -1
        end
        offset = (v.Lane % 2) * laneoffset[v.Lane + 1] * offsetFactor
      end
      local starttime = v.StartTime + offset
      local endtime = v.EndTime
      if endtime > 0 then
        endtime = endtime + offset
      end
      newobj = utils.CreateHitObject(starttime, v.Lane, endtime, v.HitSound, v.EditorLayer)
      table.insert(objectlist, newobj)
    end
    actions.RemoveHitObjectBatch(map.HitObjects)
    actions.PlaceHitObjectBatch(objectlist)
  end
  imgui.End()
end

function get(identifier, defaultValue)
  return state.GetValue(identifier) or defaultValue
end