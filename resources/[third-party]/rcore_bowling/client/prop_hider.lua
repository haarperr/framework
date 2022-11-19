local hideProps = {
    {vector3(304.74, 248.31, 103.29), -563331074},
    {vector3(308.43, 239.97, 103.29), -563331074},
    {vector3(316.77, 240.76, 103.29), -563331074},
    {vector3(325.16, 241.07, 103.29), -563331074},
}

Citizen.CreateThread(function()
    for _, p in pairs(hideProps) do
        CreateModelHide(
            p[1].x,
            p[1].y,
            p[1].z,
            1.0, 
            p[2], 
            true
        )
    end
end)