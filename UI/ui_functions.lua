local lovely = require("lovely")
local nativefs = require("nativefs")

G.FUNCS.apply_settings = function(e)
  S.SETTINGS = deepcopy(S.TEMP_SETTINGS)
  S:write_settings()
  G:set_language()
end

G.FUNCS.saturn_preferences_button = function(e)
  S.TEMP_SETTINGS = deepcopy(S.SETTINGS)
  return G.FUNCS.saturn_preferences()
end

function s_create_toggle(args)
  args = args or {}
  args.active_colour = args.active_colour or G.C.RED
  args.inactive_colour = args.inactive_colour or G.C.BLACK
  args.w = args.w or 3
  args.h = args.h or 0.5
  args.scale = args.scale or 1
  args.label = args.label or nil
  args.label_scale = args.label_scale or 0.4
  args.ref_table = args.ref_table or {}
  args.ref_value = args.ref_value or "test"

  local check = Sprite(0, 0, 0.5 * args.scale, 0.5 * args.scale, G.ASSET_ATLAS["icons"], { x = 1, y = 0 })
  check.states.drag.can = false
  check.states.visible = false

  local info = nil
  if args.info then
    info = {}
    for k, v in ipairs(args.info) do
      table.insert(info, {
        n = G.UIT.R,
        config = { align = "cm", minh = 0.05 },
        nodes = {
          { n = G.UIT.T, config = { text = v, scale = 0.25, colour = G.C.UI.TEXT_LIGHT } },
        },
      })
    end
    info = { n = G.UIT.R, config = { align = "cm", minh = 0.05 }, nodes = info }
  end

  local t = {
    n = args.col and G.UIT.C or G.UIT.R,
    config = { align = "cm", padding = 0.1, r = 0.1, colour = G.C.CLEAR, focus_args = { funnel_from = true } },
    nodes = {
      {
        n = G.UIT.C,
        config = { align = "cl", minw = 0.3 * args.w },
        nodes = {
          {
            n = G.UIT.C,
            config = { align = "cm", r = 0.1, colour = G.C.BLACK },
            nodes = {
              {
                n = G.UIT.C,
                config = {
                  align = "cm",
                  r = 0.1,
                  padding = 0.03,
                  minw = 0.4 * args.scale,
                  minh = 0.4 * args.scale,
                  outline_colour = G.C.WHITE,
                  outline = 1.2 * args.scale,
                  line_emboss = 0.5 * args.scale,
                  ref_table = args,
                  colour = args.inactive_colour,
                  button = "toggle_button",
                  button_dist = 0.2,
                  hover = true,
                  toggle_callback = args.callback,
                  func = "toggle",
                  focus_args = { funnel_to = true },
                },
                nodes = {
                  { n = G.UIT.O, config = { object = check } },
                },
              },
            },
          },
        },
      },
    },
  }
  if args.label then
    ins = {
      n = G.UIT.C,
      config = { align = "cr", minw = args.w },
      nodes = {
        { n = G.UIT.T, config = { text = args.label, scale = args.label_scale, colour = G.C.UI.TEXT_LIGHT } },
        { n = G.UIT.B, config = { w = 0.1, h = 0.1 } },
      },
    }
    table.insert(t.nodes, 1, ins)
  end
  if args.info then
    t = { n = args.col and G.UIT.C or G.UIT.R, config = { align = "cm" }, nodes = {
      t,
      info,
    } }
  end
  return t
end

function s_create_tabs(args)
  args = args or {}
  args.colour = args.colour or G.C.RED
  args.tab_alignment = args.tab_alignment or "cm"
  args.opt_callback = args.opt_callback or nil
  args.scale = args.scale or 1
  args.tab_w = args.tab_w or 0
  args.tab_h = args.tab_h or 0
  args.text_scale = (args.text_scale or 0.5)
  args.tabs = args.tabs
    or {
      {
        label = "tab 1",
        chosen = true,
        func = nil,
        tab_definition_function = function()
          return {
            n = G.UIT.ROOT,
            config = { align = "cm" },
            nodes = {
              { n = G.UIT.T, config = { text = "A", scale = 1, colour = G.C.UI.TEXT_LIGHT } },
            },
          }
        end,
      },
      {
        label = "tab 2",
        chosen = false,
        tab_definition_function = function()
          return {
            n = G.UIT.ROOT,
            config = { align = "cm" },
            nodes = {
              { n = G.UIT.T, config = { text = "B", scale = 1, colour = G.C.UI.TEXT_LIGHT } },
            },
          }
        end,
      },
      {
        label = "tab 3",
        chosen = false,
        tab_definition_function = function()
          return {
            n = G.UIT.ROOT,
            config = { align = "cm" },
            nodes = {
              { n = G.UIT.T, config = { text = "C", scale = 1, colour = G.C.UI.TEXT_LIGHT } },
            },
          }
        end,
      },
    }

  local tab_buttons = {}

  for k, v in ipairs(args.tabs) do
    if v.chosen then
      args.current = { k = k, v = v }
    end
    tab_buttons[#tab_buttons + 1] = UIBox_button({
      id = "tab_but_" .. (v.label or ""),
      ref_table = v,
      button = "change_tab",
      colour = args.colour,
      label = { v.label },
      minh = 0.8 * args.scale,
      minw = 2.5 * args.scale,
      col = true,
      choice = true,
      scale = args.text_scale,
      chosen = v.chosen,
      func = v.func,
      focus_args = { type = "none" },
    })
  end
<<<<<<< Updated upstream

  local t = {
    n = G.UIT.R,
    config = { padding = 0.0, align = "cm", colour = G.C.CLEAR },
    nodes = {
      {
        n = G.UIT.R,
        config = { align = "cm", colour = G.C.CLEAR },
        nodes = {
          (#args.tabs > 1 and not args.no_shoulders) and {
            n = G.UIT.C,
            config = {
              minw = 0.7,
              align = "cm",
              colour = G.C.CLEAR,
              func = "set_button_pip",
              focus_args = {
                button = "leftshoulder",
                type = "none",
                orientation = "cm",
                scale = 0.7,
                offset = { x = -0.1, y = 0 },
=======
  return tab_buttons
end

function s_create_card_display(args)
  args = args or {}
  args._type = args._type or 'Joker'
  args.col = args.col or 5
  args.row = args.row or 2
  args.specific_center = args.specific_center or nil
  local deck_tables = {}
  local cards_per_page = args.col*args.row
  local current_center = 0

  S.card_display = {}

  for i = 1, args.row do
    S.card_display[i] = CardArea(
      G.ROOM.T.x + 0.2*G.ROOM.T.w/args.row,G.ROOM.T.h,
      args.col*G.CARD_W,
      0.95*G.CARD_H, 
      {card_limit = args.col, type = 'title', highlight_limit = 0, collection = false})
    table.insert(deck_tables, 
    {n=G.UIT.R, config={align = "cm", padding = 0.07, no_fill = true}, nodes={
      {n=G.UIT.O, config={colour = G.C.CLEAR, object = S.card_display[i]}}
    }}
    )
  end

  if args.specific_center then
    local center = args.specific_center
    local card = Card(S.card_display[1].T.x + S.card_display[1].T.w/args.row, S.card_display[1].T.y, G.CARD_W, G.CARD_H, nil, center)
    if args._type == 'Joker' then
      card.sticker = get_joker_win_sticker(center)
    end
    S.card_display[1]:emplace(card)
    return {
      {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.CLEAR, emboss = 0.05}, nodes=deck_tables},
    }
  end

  for i = 1, args.row do
    for j = 1, args.col do
      current_center = current_center + 1
      local center = G.P_CENTER_POOLS[args._type][current_center + (S.current_page*(args.row*args.col))]
      if not center then break end
      local card = Card(S.card_display[i].T.x + S.card_display[i].T.w/args.row, S.card_display[i].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center)
      card.s_stats = true
      if args._type == 'Joker' then
        card.sticker = get_joker_win_sticker(center)
      end
      S.card_display[i]:emplace(card)
    end
  end
  
  local t = {
    {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.CLEAR, emboss = 0.05}, nodes=deck_tables}, 
    {n=G.UIT.R, config={align = "cm",}, nodes = s_create_page_cycle_options({_type = args._type, colour = lighten(G.C.GREEN, 0.03), _type = args._type, row = args.row, col = args.col})}
  }
  return t
end

local card_click_ref = Card.click
function Card:click() 
  if self.s_stats then
    G.FUNCS.card_stats(self)
  end
  card_click_ref(self)
end

function s_create_page_cycle_options(args)
  args = args or {}
  args._type = args._type or 'Joker'
  args.col = args.col or 5
  args.row = args.row or 2

  S.current_page_text = (S.current_page+1)

  local t = {
    {
      n = G.UIT.C,
      config = {
        align = 'cm',
        colour = G.C.CLEAR,
      },
      nodes = {
        {
          n = G.UIT.R,
          config = {
            id = 'page_left',
            button = 'statview_page_cycle',
            ref_table = {
              _type = args._type,
              col = args.col,
              row = args.row,
              current = S.current_page,
              dir = -1,
            },
            shadown = false,
            minw = 0.66,
            minh = 0.66,
            hover = true,
            align = "cm",
            colour = args.colour or G.C.BLACK,
            r = 0.1,
            padding = 0.2,
            outline_colour = lighten(G.C.JOKER_GREY, 0.5),
            outline = 1.15,
          },
          nodes = {
            {
              n = G.UIT.T,
              config = {
                text = '<',
                scale = 0.4,
                colour = G.C.UI.TEXT_LIGHT,
                shadow = true,
              },
            },
          }
        }
      }
    },
    { 
      n = G.UIT.C,
      config = {
          align = "cm",
          colour = G.C.CLEAR,
          minw = 0.2,
          r = 0.1,
          padding = 0,
      },
    },
    {
      n = G.UIT.C,
      config = {
        align = 'cm',
        colour = G.C.CLEAR,
      },
      nodes = {
        {
          n = G.UIT.R,
          config = {
              align = "cm",
              colour = args.colour or G.C.BLACK,
              minh = 0.66,
              r = 0.1,
              padding = 0.2,
              minw = 2,
              outline_colour = lighten(G.C.JOKER_GREY, 0.5),
              outline = 1.15,
          },
          nodes = {
            { 
              n = G.UIT.C,
              config = {
                  align = "cm",
                  colour = G.C.CLEAR,
                  minw = 0.5,
                  r = 0.1,
                  padding = 0,
              },
              nodes = {
                {
                  n = G.UIT.T,
                  config = {
                    id = 'current_page_num',
                    ref_table = S,
                    ref_value = 'current_page_text',
                    scale = 0.4,
                    colour = G.C.UI.TEXT_LIGHT,
                    shadow = true,
                  },
                },
              },
            },
            { 
              n = G.UIT.C,
              config = {
                  align = "cm",
                  colour = G.C.CLEAR,
                  minw = 0.2,
                  r = 0.1,
                  padding = 0,
              },
              nodes = {
                {
                  n = G.UIT.T,
                  config = {
                    text = '/',
                    scale = 0.4,
                    minw = 0.5,
                    colour = G.C.UI.TEXT_LIGHT,
                    shadow = true,
                  },
                },
              },
            },
            { 
              n = G.UIT.C,
              config = {
                  align = "cm",
                  colour = G.C.CLEAR,
                  minw = 0.5,
                  r = 0.1,
                  padding = 0,
              },
              nodes = {
                {
                  n = G.UIT.T,
                  config = {
                    text = tostring(math.ceil((#G.P_CENTER_POOLS[args._type]/(args.row*args.col)))),
                    scale = 0.4,
                    colour = G.C.UI.TEXT_LIGHT,
                    shadow = true,
                  },
                },
              }
            }
          }
        }
      }
    },
    { 
      n = G.UIT.C,
      config = {
          align = "cm",
          colour = G.C.CLEAR,
          minw = 0.2,
          r = 0.1,
          padding = 0,
      },
    },
    {
      n = G.UIT.C,
      config = {
        align = 'cm',
        colour = G.C.CLEAR,
      },
      nodes = {
        {
          n = G.UIT.R,
          config = {
            id = 'page_right',
            button = 'statview_page_cycle',
            ref_table = {
              _type = args._type,
              col = args.col,
              row = args.row,
              current = S.current_page,
              dir = 1,
            },
            shadown = false,
            minw = 0.66,
            minh = 0.66,
            hover = true,
            align = "cm",
            colour = args.colour or G.C.BLACK,
            r = 0.1,
            padding = 0.2,
            outline_colour = lighten(G.C.JOKER_GREY, 0.5),
            outline = 1.15,
          },
          nodes = {
            {
              n = G.UIT.T,
              config = {
                text = '>',
                scale = 0.4,
                colour = G.C.UI.TEXT_LIGHT,
                shadow = true,
              },
            },
          }
        }
      }
    }
  }
  return t
end

function s_create_general_stats_page(args)

  --   "c_cards_sold",
  --   "c_hands_played",
  --   "c_jokers_sold",
  --   "c_vouchers_bought",
  --   "c_planetarium_used",
  --   "c_wins",
  --   "c_shop_rerolls",
  --   "c_cards_discarded",
  --   "c_tarots_bought",
  --   "c_cards_played",
  --   "c_shop_dollars_spent",
  --   "c_face_cards_played",
  --   "c_planets_bought",
  --   "c_single_hand_round_streak",
  --   "c_tarot_reading_used",
  --   "c_rounds",
  --   "c_playing_cards_bought",
  --   "c_dollars_earned",
  --   "c_losses",
  --   "c_round_interest_cap_streak",

  local career_stats = G.PROFILES[G.SETTINGS.profile].career_stats

  return nil
end

function s_create_stats_page(args)
  if not args.ability then return end

  local t = {
    {
      n = G.UIT.R,
      config = {
        align = 'cm',
      },
      nodes = {
        {
          n = G.UIT.R,
          config = {
            align = 'cm',
            padding = 0.1,
          },
          nodes = s_create_card_display({_type = args.ability.set, col = 1, row = 1, specific_center = args.config.center})
        },
        (args.ability.set == 'Joker' and s_create_joker_stats_page(args)) or
        s_create_consumable_stats_page(args)
      }
    }
  }
  return t
end

function s_create_joker_stats_page(args)
  if not (args.ability and args.ability.set == 'Joker') then return end

  local t = {
    n = G.UIT.R,
    config = {
      align = 'cm',
      padding = 0.1,
    },
    nodes = s_create_joker_wl(args)
  }
  return t
end

function s_create_consumable_stats_page(args)
  if not (args.ability and args.ability.set ~= 'Joker') then return end

  local t = {
    n = G.UIT.R,
    config = {
      align = 'cm',
      padding = 0.1,
    },
    nodes = s_create_consumable_usage(args)
  }
  return t
end

function s_create_consumable_usage(args) 
  local _set = args.ability.set
  local used = G.PROFILES[G.SETTINGS.profile]["consumeable_usage"][args.config.center.key].count
  local total_used = 0

  for k, v in pairs(G.P_CENTERS) do
    if v.set == _set then
      total_used = total_used + G.PROFILES[G.SETTINGS.profile]["consumeable_usage"][k].count
    end
  end

  local t = {
    {
      n = G.UIT.R,
      config = {
        align = 'cm',
        padding = 0.2,
        r = 0.1,
        colour = G.C.L_BLACK,
        outline_colour = lighten(G.C.JOKER_GREY, 0.5),
        outline = 1.15,
      },
      nodes = {
        {
          n = G.UIT.R,
          config = {
            align = 'cm',
            padding = 0.02,
          },
          nodes = {
            {
              n = G.UIT.T,
              config = {
                align = 'cm',
                text = 'Usage',
                scale = 0.4,
                colour = G.C.UI.TEXT_LIGHT,
                shadow = true,
              },
            },
          }
        },
        {
          n = G.UIT.R,
          config = {
            align = 'cm',
            padding = 0.2,
            r = 0.1,
            colour = G.C.BLACK,
            outline_colour = lighten(G.C.JOKER_GREY, 0.5),
            outline = 1.15,
          },
          nodes = {
            {
              n = G.UIT.R,
              config = {
                align = 'cm',
              },
              nodes = {
                {
                  n = G.UIT.T,
                  config = {
                    align = 'cm',
                    text = 'Total used: '..used,
                    scale = 0.4,
                    colour = G.C.UI.TEXT_LIGHT,
                    shadow = true,
                  },
                }
              }
            },
            {
              n = G.UIT.R,
              config = {
                align = 'cm',
              },
              nodes = {
                {
                  n = G.UIT.T,
                  config = {
                    align = 'cm',
                    text = round2((used/total_used)*100, 2)..'% of Total '..args.ability.set..'s used',
                    scale = 0.4,
                    colour = G.C.UI.TEXT_LIGHT,
                    shadow = true,
                  },
                }
              }
            }
          }
        }
      }
    }
  }
  return t
end

-- stole this from somewhere online
-- why does lua not have it built in
function round2(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function s_create_joker_wl(args)
  if not (args.ability and args.ability.set == 'Joker') then return end
  local wins = {}
  local losses = {}
  local win_total = 0
  local loss_total = 0

  for i = 1, 8 do
    wins[i] = G.PROFILES[G.SETTINGS.profile]['joker_usage'][args.config.center.key].wins[i] or 0
    win_total = win_total + (G.PROFILES[G.SETTINGS.profile]['joker_usage'][args.config.center.key].wins[i] or 0)
  end

  for i = 1, 8 do
    losses[i] = G.PROFILES[G.SETTINGS.profile]['joker_usage'][args.config.center.key].losses[i] or 0
    loss_total = loss_total + (G.PROFILES[G.SETTINGS.profile]['joker_usage'][args.config.center.key].losses[i] or 0)
  end

  local t = {
    {
      n = G.UIT.R,
      config = {
        align = 'cm',
        padding = 0.2,
        r = 0.1,
        colour = G.C.L_BLACK,
        outline_colour = lighten(G.C.JOKER_GREY, 0.5),
        outline = 1.15,
      },
      nodes = {
        {
          n = G.UIT.R,
          config = {
            align = 'cm',
            padding = 0.02,
          },
          nodes = {
            {
              n = G.UIT.T,
              config = {
                align = 'cm',
                text = 'Wins/Losses',
                scale = 0.4,
                colour = G.C.UI.TEXT_LIGHT,
                shadow = true,
>>>>>>> Stashed changes
              },
            },
            nodes = {},
          } or nil,
          {
            n = G.UIT.C,
            config = {
              id = args.no_shoulders and "no_shoulders" or "tab_shoulders",
              ref_table = args,
              align = "cm",
              padding = 0.15,
              group = 1,
              collideable = true,
              focus_args = #args.tabs > 1
                  and { type = "tab", nav = "wide", snap_to = args.snap_to_nav, no_loop = args.no_loop }
                or nil,
            },
            nodes = tab_buttons,
          },
          (#args.tabs > 1 and not args.no_shoulders) and {
            n = G.UIT.C,
            config = {
              minw = 0.7,
              align = "cm",
              colour = G.C.CLEAR,
              func = "set_button_pip",
              focus_args = {
                button = "rightshoulder",
                type = "none",
                orientation = "cm",
                scale = 0.7,
                offset = { x = 0.1, y = 0 },
              },
            },
            nodes = {},
          } or nil,
        },
      },
      {
        n = G.UIT.R,
        config = {
          align = args.tab_alignment,
          padding = args.padding or 0.1,
          no_fill = true,
          minh = args.tab_h,
          minw = args.tab_w,
        },
        nodes = {
          {
            n = G.UIT.O,
            config = {
              id = "tab_contents",
              object = UIBox({
                definition = args.current.v.tab_definition_function(args.current.v.tab_definition_function_args),
                config = { offset = { x = 0, y = 0 } },
              }),
            },
          },
        },
      },
    },
  }

  return t
end

function s_create_feature_options(args)
  local name = args.name or ""
  local box_colour = args.box_colour or G.C.L_BLACK
  local toggle_ref = args.toggle_ref
  local config_button = args.config_button or nil

  local t = {
    n = G.UIT.R,
    config = {
      align = "cm",
      padding = 0.05,
      colour = box_colour,
      r = 0.3,
    },
    nodes = {
      {
        n = G.UIT.C,
        config = { align = "cm", padding = 0.1 },
        nodes = {
          {
            n = G.UIT.O,
            config = {
              object = DynaText({ string = "Enable " .. name, colours = { G.C.WHITE }, shadow = false, scale = 0.5 }),
            },
          },
        },
      },
      {
        n = G.UIT.C,
        config = { align = "cm", padding = 0.1 },
        nodes = {
          s_create_toggle({
            ref_table = toggle_ref,
            ref_value = "enabled",
            active_colour = G.C.BOOSTER,
            callback = function(x) end,
            col = true,
          }),
        },
      },
      config_button and {
        n = G.UIT.C,
        config = { align = "cm", padding = 0.1 },
        nodes = {
          UIBox_button({
            label = { "Config" },
            button = config_button,
            minw = 2,
            minh = 0.75,
            scale = 0.5,
            colour = G.C.BOOSTER,
            col = true,
          }),
        },
      },
    },
  }
  return t
end

function s_create_config_options(settings, args)
  col_left = { n = G.UIT.C, config = { align = "tl", padding = 0.05 }, nodes = {} }
  col_right = { n = G.UIT.C, config = { align = "tl", padding = 0.05 }, nodes = {} }

  for k, v in pairs(settings) do
    col_left.nodes[#col_left.nodes + 1] = {
      n = G.UIT.R,
      config = { align = "cl", padding = 0.1 },
      nodes = {
        {
          n = G.UIT.R,
          config = { align = "cl", padding = 0.075 },
          nodes = {
            {
              n = G.UIT.O,
              config = {
                object = DynaText({
                  string = v.label,
                  colours = { G.C.WHITE },
                  shadow = false,
                  scale = 0.5,
                }),
              },
            },
          },
        },
      },
    }
    print(inspectDepth(v))
    col_right.nodes[#col_right.nodes + 1] = s_create_toggle({
      label = "",
      ref_table = v.table,
      ref_value = v.val,
      active_colour = G.C.BOOSTER,
    })
  end
  local t = {
    n = G.UIT.R,
    config = {
      align = "tm",
      padding = 0.05,
    },
    nodes = {
      col_left,
      col_right,
    },
  }
  return t
end

function s_create_generic_options(args)
  args = args or {}
  local apply_func = args.apply_func or "apply_settings"
  local back_func = args.back_func or "exit_overlay_menu"
  local contents = args.contents or { n = G.UIT.T, config = { text = "EMPTY", colour = G.C.UI.RED, scale = 0.4 } }
  if args.infotip then
    G.E_MANAGER:add_event(Event({
      blocking = false,
      blockable = false,
      timer = "REAL",
      func = function()
        if G.OVERLAY_MENU then
          local _infotip_object = G.OVERLAY_MENU:get_UIE_by_ID("overlay_menu_infotip")
          if _infotip_object then
            _infotip_object.config.object:remove()
            _infotip_object.config.object = UIBox({
              definition = overlay_infotip(args.infotip),
              config = { offset = { x = 0, y = 0 }, align = "bm", parent = _infotip_object },
            })
          end
        end
        return true
      end,
    }))
  end

  return {
    n = G.UIT.ROOT,
    config = {
      align = "cm",
      minw = G.ROOM.T.w * 5,
      minh = G.ROOM.T.h * 5,
      padding = 0.1,
      r = 0.1,
      colour = args.bg_colour or { G.C.GREY[1], G.C.GREY[2], G.C.GREY[3], 0.7 },
    },
    nodes = {
      {
        n = G.UIT.R,
        config = {
          align = "cm",
          minh = 1,
          r = 0.3,
          padding = 0.07,
          minw = 1,
          colour = args.outline_colour or G.C.JOKER_GREY,
          emboss = 0.1,
        },
        nodes = {
          {
            n = G.UIT.C,
            config = { align = "cm", minh = 1, r = 0.2, padding = 0.2, minw = 1, colour = args.colour or G.C.L_BLACK },
            nodes = {
              {
                n = G.UIT.R,
                config = { align = "cm", padding = args.padding or 0.2, minw = args.minw or 7 },
                nodes = contents,
              },
              not args.no_apply and {
                n = G.UIT.R,
                config = {
                  id = args.apply_id or "overlay_menu_apply_button",
                  align = "cm",
                  minw = 2.5,
                  button_delay = args.back_delay,
                  padding = 0.1,
                  r = 0.1,
                  hover = true,
                  colour = args.apply_colour or G.C.GREEN,
                  button = apply_func,
                  shadow = true,
                  focus_args = { nav = "wide", button = "a", snap_to = args.snap_back },
                },
                nodes = {
                  {
                    n = G.UIT.R,
                    config = { align = "cm", padding = 0, no_fill = true },
                    nodes = {
                      {
                        n = G.UIT.T,
                        config = {
                          id = args.apply_id or nil,
                          text = args.apply_label or "Apply",
                          scale = 0.5,
                          colour = G.C.UI.TEXT_LIGHT,
                          shadow = true,
                          func = not args.no_pip and "set_button_pip" or nil,
                          focus_args = not args.no_pip and { button = args.apply_button or "a" } or nil,
                        },
                      },
                    },
                  },
                },
              },
              not args.no_back and {
                n = G.UIT.R,
                config = {
                  id = args.back_id or "overlay_menu_back_button",
                  align = "cm",
                  minw = 2.5,
                  button_delay = args.back_delay,
                  padding = 0.1,
                  r = 0.1,
                  hover = true,
                  colour = args.back_colour or G.C.ORANGE,
                  button = back_func,
                  shadow = true,
                  focus_args = { nav = "wide", button = "b", snap_to = args.snap_back },
                },
                nodes = {
                  {
                    n = G.UIT.R,
                    config = { align = "cm", padding = 0, no_fill = true },
                    nodes = {
                      {
                        n = G.UIT.T,
                        config = {
                          id = args.back_id or nil,
                          text = args.back_label or localize("b_back"),
                          scale = 0.5,
                          colour = G.C.UI.TEXT_LIGHT,
                          shadow = true,
                          func = not args.no_pip and "set_button_pip" or nil,
                          focus_args = not args.no_pip and { button = args.back_button or "b" } or nil,
                        },
                      },
                    },
                  },
                },
              } or nil,
            },
          },
        },
      },
      {
        n = G.UIT.R,
        config = { align = "cm" },
        nodes = {
          { n = G.UIT.O, config = { id = "overlay_menu_infotip", object = Moveable() } },
        },
      },
    },
  }
end
