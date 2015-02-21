return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 50,
  height = 20,
  tilewidth = 20,
  tileheight = 20,
  properties = {},
  tilesets = {
    {
      name = "All2",
      firstgid = 1,
      tilewidth = 20,
      tileheight = 20,
      spacing = 0,
      margin = 0,
      image = "../assets/tileset.png",
      imagewidth = 160,
      imageheight = 380,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {
        {
          name = "Solid",
          tile = 136,
          properties = {}
        }
      },
      tiles = {
        {
          id = 122,
          terrain = { -1, 0, 0, 0 }
        },
        {
          id = 123,
          terrain = { 0, -1, 0, 0 }
        },
        {
          id = 124,
          terrain = { -1, -1, -1, 0 }
        },
        {
          id = 125,
          terrain = { -1, -1, 0, -1 }
        },
        {
          id = 126,
          terrain = { -1, -1, 0, 0 }
        },
        {
          id = 127,
          terrain = { 0, -1, 0, -1 }
        },
        {
          id = 128,
          terrain = { -1, 0, 0, -1 }
        },
        {
          id = 129,
          terrain = { 0, -1, -1, 0 }
        },
        {
          id = 130,
          terrain = { 0, 0, -1, 0 }
        },
        {
          id = 131,
          terrain = { 0, 0, 0, -1 }
        },
        {
          id = 132,
          terrain = { -1, 0, -1, -1 }
        },
        {
          id = 133,
          terrain = { 0, -1, -1, -1 }
        },
        {
          id = 134,
          terrain = { -1, 0, -1, 0 }
        },
        {
          id = 135,
          terrain = { 0, 0, -1, -1 }
        },
        {
          id = 136,
          terrain = { 0, 0, 0, 0 }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "background",
      x = 0,
      y = 0,
      width = 50,
      height = 20,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 57, 58, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 65, 66, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102
      }
    },
    {
      type = "tilelayer",
      name = "back",
      x = 0,
      y = 0,
      width = 50,
      height = 20,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 89, 90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 89, 90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 89, 90, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 97, 98, 0, 0, 0, 0, 0, 0, 0, 0, 89, 90, 0, 0, 0, 0, 0, 0, 0, 97, 98, 0, 0, 0, 0, 0, 0, 0, 89, 90, 0, 0, 0, 0, 0, 0, 0, 0, 97, 98, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 97, 98, 0, 0, 0, 0, 0, 0, 0, 97, 98, 0, 0, 0, 0, 0, 0, 0, 97, 98, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 89, 90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 97, 98, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 89, 90, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 97, 98, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "objs",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 300,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "waterleft"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 580,
          y = 320,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "waterright"
          }
        },
        {
          name = "",
          type = "lock",
          shape = "rectangle",
          x = 320,
          y = 320,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 64,
          visible = true,
          properties = {
            ["change"] = "waterleft"
          }
        },
        {
          name = "",
          type = "lock",
          shape = "rectangle",
          x = 540,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 64,
          visible = true,
          properties = {
            ["change"] = "waterright"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "left2"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 740,
          y = 140,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "right2"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 691,
          y = 71,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 99,
          visible = true,
          properties = {
            ["change"] = "right2"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 246,
          y = 70,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 99,
          visible = true,
          properties = {
            ["change"] = "left2"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 140,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "left2"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 120,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "left2"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 740,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "right2"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 740,
          y = 120,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "right2"
          }
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 900,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 700,
          y = 180,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 680,
          y = 180,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 540,
          y = 180,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 260,
          y = 180,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 160,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 60,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 20,
          y = 180,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 40,
          y = 180,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 286,
          y = 151,
          width = 28,
          height = 31,
          rotation = 0,
          visible = true,
          properties = {
            ["TO"] = "ice_key1"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 466,
          y = 130,
          width = 28,
          height = 48,
          rotation = 0,
          visible = true,
          properties = {
            ["TO"] = "sanctuum"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 644,
          y = 149,
          width = 30,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["TO"] = "ice_key2"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 85,
          y = 128,
          width = 29,
          height = 33,
          rotation = 0,
          visible = true,
          properties = {
            ["TO"] = "ice_timejump"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 848,
          y = 127,
          width = 27,
          height = 34,
          rotation = 0,
          visible = true,
          properties = {
            ["TO"] = "ice_boss"
          }
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 940,
          y = 300,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 920,
          y = 340,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 900,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 880,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 860,
          y = 380,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 840,
          y = 380,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 820,
          y = 380,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 800,
          y = 380,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 780,
          y = 380,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 760,
          y = 380,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 740,
          y = 380,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 720,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 700,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 680,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 640,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 660,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 620,
          y = 340,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 600,
          y = 340,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 560,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 520,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 500,
          y = 380,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 480,
          y = 380,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 460,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 440,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 420,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 400,
          y = 340,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 380,
          y = 340,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 360,
          y = 340,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 340,
          y = 320,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 300,
          y = 320,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 260,
          y = 300,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 240,
          y = 320,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 220,
          y = 340,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 200,
          y = 340,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 180,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 140,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 160,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 120,
          y = 380,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 100,
          y = 380,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 80,
          y = 380,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 60,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "grass",
          shape = "rectangle",
          x = 40,
          y = 360,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 145,
          y = 324,
          width = 30,
          height = 35,
          rotation = 0,
          visible = true,
          properties = {
            ["TO"] = "ice_puzzle_easy"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 826,
          y = 344,
          width = 30,
          height = 37,
          rotation = 0,
          visible = true,
          properties = {
            ["TO"] = "ice_time"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 280,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "waterleft"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 260,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "waterleft"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 240,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "waterleft"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 580,
          y = 300,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "waterright"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 580,
          y = 280,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "waterright"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 580,
          y = 260,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "waterright"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 375,
          y = 282,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 31,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 165,
          y = 242,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 31,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 680,
          y = 262,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 31,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 801,
          y = 319,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 31,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 490,
          y = 340,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 31,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 840,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "boss"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 860,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "boss"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 840,
          y = 140,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "boss"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 860,
          y = 140,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "boss"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 800,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 95,
          visible = true,
          properties = {
            ["bigkey"] = "ice",
            ["change"] = "boss"
          }
        }
      }
    },
    {
      type = "tilelayer",
      name = "Water",
      x = 0,
      y = 0,
      width = 50,
      height = 20,
      visible = true,
      opacity = 0.27,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109,
        111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111,
        111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111,
        111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111,
        111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111,
        111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111,
        111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111,
        111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111,
        111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111,
        111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111,
        111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111
      }
    },
    {
      type = "tilelayer",
      name = "Ground",
      x = 0,
      y = 0,
      width = 50,
      height = 20,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137,
        137, 112, 112, 112, 112, 112, 112, 112, 112, 112, 137, 112, 112, 112, 112, 112, 112, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 112, 112, 112, 112, 112, 112, 112, 137, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 137,
        137, 112, 0, 0, 112, 112, 0, 0, 0, 112, 137, 112, 0, 0, 0, 0, 112, 112, 112, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 112, 112, 0, 0, 0, 0, 0, 112, 137, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137,
        112, 112, 0, 0, 0, 0, 0, 0, 0, 112, 137, 112, 0, 0, 0, 0, 0, 0, 112, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 112, 0, 0, 0, 0, 0, 0, 112, 137, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137,
        112, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 112, 0, 0, 0, 0, 0, 0, 112, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 112, 0, 0, 0, 0, 0, 0, 112, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137,
        112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137,
        112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137,
        112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137,
        112, 0, 0, 112, 112, 112, 112, 112, 112, 112, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 0, 0, 112, 137,
        112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 0, 0, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 137,
        137, 137, 137, 137, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 0, 0, 0, 0, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 137, 137, 137, 137, 137,
        137, 137, 112, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 112, 112, 112, 112, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 137, 137, 137, 137,
        137, 137, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 112, 137, 137,
        137, 137, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 137,
        137, 137, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137,
        137, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 137,
        137, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 112, 112, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137, 137,
        137, 112, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 112, 137, 137, 137, 137, 112, 112, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 137, 137,
        137, 112, 112, 112, 0, 0, 0, 112, 112, 112, 112, 137, 137, 137, 137, 137, 137, 137, 137, 137, 112, 112, 112, 112, 0, 0, 112, 112, 112, 112, 137, 112, 112, 112, 112, 112, 112, 0, 0, 0, 0, 0, 0, 0, 112, 112, 112, 137, 137, 137,
        137, 137, 137, 112, 112, 112, 112, 112, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 112, 112, 112, 112, 137, 137, 137, 137, 137, 137, 137, 137, 137, 112, 112, 112, 112, 112, 112, 112, 112, 112, 137, 137, 137, 137, 137
      }
    },
    {
      type = "objectgroup",
      name = "Zones",
      visible = false,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 178.667,
          y = 20,
          width = 602.667,
          height = 201.333,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = -2.66667,
          y = 21.3333,
          width = 224,
          height = 180,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 718.667,
          y = 18.6667,
          width = 262.667,
          height = 182.667,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 254.667,
          y = 180,
          width = 364,
          height = 220,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 20,
          y = 200,
          width = 296,
          height = 200,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 561.333,
          y = 200,
          width = 418.667,
          height = 200,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
