local lovely = require("lovely")
local nativefs = require("nativefs")

-- putting the saturn button on the main menu
local create_UIBox_main_menu_buttons_ref = create_UIBox_main_menu_buttons
function create_UIBox_main_menu_buttons()
  local text_scale = 0.45
  local saturn_features_button = UIBox_button({
    id = "saturn_features_button",
    minh = 1.35,
    minw = 1.85,
    col = true,
    button = "saturn_features_button",
    colour = G.C.SECONDARY_SET.Planet,
    label = { "Saturn" },
    scale = text_scale * 1.2,
  })
  local menu = create_UIBox_main_menu_buttons_ref()
  local spacer = G.F_QUIT_BUTTON and { n = G.UIT.C, config = { align = "cm", minw = 0.2 }, nodes = {} } or nil
  table.insert(menu.nodes[1].nodes[1].nodes[2].nodes, 2, spacer)
  table.insert(menu.nodes[1].nodes[1].nodes[2].nodes, 3, saturn_features_button)
  menu.nodes[1].nodes[1].config =
    { align = "cm", padding = 0.15, r = 0.1, emboss = 0.1, colour = G.C.L_BLACK, mid = true }
  return menu
end

-- main tabs

G.FUNCS.s_change_tab = function(e)
  local tab_config = S.TAB_FUNCS[e.config.tab_func]()
  G.OVERLAY_MENU:remove()
  G.OVERLAY_MENU = UIBox({
    	definition = s_create_options({
      		apply_func = 'apply_settings',
      		back_func = 'options',
      		tabs = s_create_tabs(tab_config._tabs),
      		nodes = s_create_buttons(tab_config._buttons),
    	}),
      config = {
        align = "cm",
        offset = {x=0,y=0},
        major = G.ROOM_ATTACH,
        bond = 'Weak',
      },
  	})
  G.OVERLAY_MENU:recalculate()
end

-- tab functions
-- modules tab
G.FUNCS.saturn_features = function(e)
  	G.SETTINGS.paused = true
    
  	local ref_table = S.TEMP_SETTINGS.modules
  	local _buttons = {
    	{label = 'StatTracker', toggle_ref = ref_table.stattrack, ref_value = 'enabled', button_ref = 'config_stattracker',},
    	{label = 'DeckViewer+', toggle_ref = ref_table.deckviewer_plus, ref_value = 'enabled', button_ref = 'config_deckviewer',},
    	{label = 'Challenger+', toggle_ref = ref_table.challenger_plus, ref_value = 'enabled', button_ref = 'config_challenger',},
      {label = 'Run Timer', toggle_ref = ref_table.run_timer, ref_value = 'enabled', button_ref = 'config_run_timer',},
  	}
  	local _tabs = {
    	{label = 'Modules'},
    	{label = 'Options', button_ref = 's_change_tab', tab_func = 'saturn_options'},
    	{label = 'Stats', button_ref = 's_change_tab', tab_func = 'saturn_stats'},
  	}

  	G.FUNCS.overlay_menu({
    	definition = s_create_options({
      		apply_func = 'apply_settings',
      		back_func = 'options',
      		tabs = s_create_tabs(_tabs),
      		nodes = s_create_buttons(_buttons),
    	})
  	})
end

function G.FUNCS.config_stattracker(e)
  G.SETTINGS.paused = true
  local ref_table = S.TEMP_SETTINGS.modules.stattrack.features.joker_tracking.groups
  local settings = {
    { val = "money_generators", table = ref_table, label = "Money Generators" },
    { val = "card_generators", table = ref_table, label = "Card Generators" },
    { val = "chips_plus", table = ref_table, label = "+Chip Jokers" },
    { val = "mult_plus", table = ref_table, label = "+Mult Jokers" },
    { val = "mult_mult", table = ref_table, label = "xMult Jokers" },
    { val = "miscellaneous", table = ref_table, label = "Miscellaneous" },
    { val = "compact_view", table = ref_table, label = "Compact View" },
  }
  local col_left = { n = G.UIT.C, config = { align = "tl", padding = 0.05 }, nodes = {} }
  local col_right = { n = G.UIT.C, config = { align = "tl", padding = 0.05 }, nodes = {} }
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
                  shadow = true,
                  scale = 0.5,
                }),
              },
            },
          },
        },
      },
    }
    col_right.nodes[#col_right.nodes + 1] = s_create_toggle({
      label = "",
      ref_table = v.table,
      ref_value = v.val,
      active_colour = G.C.BOOSTER,
    })
  end
  local args = {}
  local apply_func = "apply_settings"
  local back_func = "saturn_preferences"
  print(inspectDepth(ref_table))
  local t = {
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
                config = { align = "cm", padding = args.padding or 0, minw = args.minw or 7 },
                nodes = {
                  {
                    n = G.UIT.R,
                    config = { align = "cm" },
                    padding = 0,
                    nodes = {
                      {
                        n = G.UIT.R,
                        config = {
                            align = "cm",
                            colour = lighten(G.C.JOKER_GREY, 0.5),
                            r = 0.1,
                            padding = 0.05,
                            emboss = 0.05,
                        },
                        nodes = {
                          {
                            n = G.UIT.R,
                            config = {
                                align = "cm",
                                colour = G.C.BLACK,
                                r = 0.1,
                                padding = 0.2,
                            },
                            nodes = {
                              {
                                n = G.UIT.O,
                                config = {
                                  object = DynaText({
                                    string = "Joker Tracking Options",
                                    colours = { G.C.WHITE },
                                    shadow = true,
                                    scale = 0.4,
                                  }),
                                },
                              }
                            }
                          }
                        }
                      },
                    },
                  },
                }
              },
              {
                n = G.UIT.R,
                config = {
                    align = "cm",
                    colour = lighten(G.C.JOKER_GREY, 0.5),
                    r = 0.1,
                    padding = 0.05,
                    emboss = 0.05,
                },
                nodes = {
                  {
                    n = G.UIT.R,
                    config = {
                        align = "cm",
                        colour = G.C.BLACK,
                        r = 0.1,
                        padding = 0.1,
                    },
                    nodes = {
                      {
                        n = G.UIT.R,
                        config = {
                          align = "cm",
                          colour = G.C.CLEAR,
                          r = 0.1,
                        },
                        nodes = {
                          col_left,
                          col_right,
                        }
                      },
                      {
                        n = G.UIT.R,
                        config = {
                          align = "bm",
                          minh = 1,
                          r = 0.2,
                          padding = 0.2,
                          colour = args.colour or G.C.CLEAR
                        },
                        nodes = {
                          not args.no_apply and {
                            n = G.UIT.R,
                            config = {
                                align = "cm",
                                colour = lighten(G.C.JOKER_GREY, 0.5),
                                r = 0.1,
                                padding = 0.06,
                                emboss = 0.05,
                            },
                            nodes = {
                              {
                                n = G.UIT.R,
                                config = {
                                  id = args.apply_id or "overlay_menu_apply_button",
                                  align = "cm",
                                  minw = args.minw or 7.8,
                                  button_delay = args.back_delay,
                                  padding = 0.13,
                                  r = 0.1,
                                  hover = true,
                                  colour = args.apply_colour or G.C.GREEN,
                                  button = apply_func,
                                  shadow = false,
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
                            }
                          },
                          not args.no_back and {
                            n = G.UIT.R,
                            config = {
                                align = "cm",
                                colour = lighten(G.C.JOKER_GREY, 0.5),
                                r = 0.1,
                                padding = 0.05,
                                emboss = 0.05,
                            },
                            nodes = {
                              {
                                n = G.UIT.R,
                                config = {
                                  id = args.back_id or "overlay_menu_back_button",
                                  align = "cm",
                                  minw = args.minw or 7.8,
                                  button_delay = args.back_delay,
                                  padding = 0.13,
                                  r = 0.1,
                                  hover = true,
                                  colour = args.back_colour or G.C.ORANGE,
                                  button = back_func,
                                  shadow = false,
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
                              },
                            }
                          }
                        },
                      },
                    }
                  }
                }
              }
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
      }
    },
  }
  G.FUNCS.overlay_menu({
    definition = t,
  })
end

-- deckviewer config
G.FUNCS.config_deckviewer = function(e)
  G.SETTINGS.paused = true

  local ref_table = S.TEMP_SETTINGS.modules.deckviewer_plus.features
  local _buttons = {
    {label = 'Hide Played Cards', toggle_ref = ref_table, ref_value = 'hide_played_cards', remove_enable = true,},
  }

  G.FUNCS.overlay_menu({
    definition = s_create_options({
      apply_func = "apply_settings",
      back_func = "saturn_features",
      title = 'Deckviewer+ Options',
      nodes = s_create_buttons(_buttons),
    })
  })
end

-- challenger config
G.FUNCS.config_challenger = function(e)
  G.SETTINGS.paused = true

  local ref_table = S.TEMP_SETTINGS.modules.challenger_plus.features
  local _buttons = {
    {label = 'Retry Button', toggle_ref = ref_table, ref_value = 'retry_button', remove_enable = true,},
    {label = 'Mass Use', toggle_ref = ref_table, ref_value = 'mass_use_button', remove_enable = true,},
  }

  G.FUNCS.overlay_menu({
    definition = s_create_options({
      apply_func = "apply_settings",
      back_func = "saturn_features",
      title = 'Challenger+ Options',
      nodes = s_create_buttons(_buttons),
    })
  })
end

-- stat view buttons

-- general stats
G.FUNCS.view_general = function(e) end

-- joker stats
G.FUNCS.view_jokers = function(e)
	G.SETTINGS.paused = true

	local card_display = {_type = 'Joker', col = 5, row = 2,}

	G.FUNCS.overlay_menu({
		definition = s_create_options({
		back_func = "saturn_stats",
		title = 'Click on a Card to view Stats',
		nodes = s_create_card_display(card_display),
		})
	})
end

-- tarot stats
G.FUNCS.view_tarots = function(e)
	G.SETTINGS.paused = true

	local card_display = {_type = 'Tarot', col = 5, row = 2,}

	G.FUNCS.overlay_menu({
		definition = s_create_options({
		back_func = "saturn_stats",
		title = 'Click on a Card to view Stats',
		nodes = s_create_card_display(card_display),
		})
	})
end

-- planet stats
G.FUNCS.view_planets = function(e)
	G.SETTINGS.paused = true

	local card_display = {_type = 'Planet', col = 5, row = 2,}

	G.FUNCS.overlay_menu({
		definition = s_create_options({
		back_func = "saturn_stats",
		title = 'Click on a Card to view Stats',
		nodes = s_create_card_display(card_display),
		})
	})
end

-- spectral stats
G.FUNCS.view_spectrals = function(e)
	G.SETTINGS.paused = true

	local card_display = {_type = 'Spectral', col = 5, row = 2,}

	G.FUNCS.overlay_menu({
		definition = s_create_options({
		back_func = 'saturn_stats',
		title = 'Click on a Card to view Stats',
		nodes = s_create_card_display(card_display),
		})
	})
end

-- deck stats
G.FUNCS.view_decks = function(e)
	G.SETTINGS.paused = true

	local deck_display = {_type = 'Back', col = 5, row = 3,}

	G.FUNCS.overlay_menu({
		definition = s_create_options({
		back_func = 'saturn_stats',
		title = 'Click on a Deck to view Stats',
		nodes = s_create_deck_display(deck_display),
		})
	})
end

-- individual card stats view buttons

-- specific card stats
G.FUNCS.card_stats = function(e)
	G.SETTINGS.paused = true

	G.FUNCS.overlay_menu({
		definition = s_create_options({
		back_func = 'view_'..e.ability.set:lower()..'s',
		title = localize({type = 'name_text', set = e.ability.set, key = e.config.center.key}),
		nodes = s_create_stats_page(e)
		})
	})
end

-- specific deck stats
G.FUNCS.deck_stats = function(e)
	G.SETTINGS.paused = true

	G.FUNCS.overlay_menu({
		definition = s_create_options({
		back_func = 'view_decks',
		title = localize({type = 'name_text', set = e.ability.set, key = e.config.center.key}),
		nodes = s_create_stats_page(e)
		})
	})
end

-- -- other button callbacks

-- page cycling for the stat card areas
G.FUNCS.statview_page_cycle = function(e)
	args = e.config.ref_table or {}
	args._type = args._type or 'Joker'
	args.col = args.col or 5
	args.row = args.row or 2
	args.dir = args.dir or 1
	local cards_per_page = args.col*args.row
	local current_center = 0

	for j = 1, args.row do
		for i = args.col, 1, -1 do
		local c = S.card_display[j]:remove_card(S.card_display[j].cards[i])
		if c then
			c:remove()
			c = nil
		end
		end
	end

	S.current_page = S.current_page + args.dir

	if S.current_page >= math.ceil(#G.P_CENTER_POOLS[args._type]/cards_per_page) then
		S.current_page = 0
	elseif S.current_page < 0 then
		S.current_page = math.ceil(#G.P_CENTER_POOLS[args._type]/cards_per_page)-1
	end

	S.current_page_text = (S.current_page+1)
	G.OVERLAY_MENU:get_UIE_by_ID('current_page_num'):update_text()

	for i = 1, args.row do
		for j = 1, args.col do
		current_center = current_center + 1
		local center = G.P_CENTER_POOLS[args._type][current_center + (S.current_page*(cards_per_page))]
		if not center then break end
		local card = Card(S.card_display[i].T.x + S.card_display[i].T.w/args.row, S.card_display[i].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center)
		card.s_stats = true
		if args._type == 'Joker' then
			card.sticker = get_joker_win_sticker(center)
		end
		S.card_display[i]:emplace(card)
		end
	end
end

G.FUNCS.use_consumeables = function(e)
	G.FUNCS:exit_overlay_menu()
	if G.consumeables and G.consumeables.cards then
		consume_cards(G.consumeables.cards)
	end
end

-- page cycling for the decks
G.FUNCS.deckview_page_cycle = function(e)
	args = e.config.ref_table or {}
	args._type = args._type or 'Back'
	args.col = args.col or 5
	args.row = args.row or 3
	args.dir = args.dir or 1
	local cards_per_page = args.col*args.row
	local current_center = 0

	for i = #S.card_display, 1, -1 do
		local c = S.card_display[i]:remove_card(S.card_display[i].cards[1])
		if c then
		c:remove()
		c = nil
		end
	end

	S.current_page = S.current_page + args.dir

	if S.current_page >= math.ceil(#G.P_CENTER_POOLS[args._type]/cards_per_page) then
		S.current_page = 0
	elseif S.current_page < 0 then
		S.current_page = math.ceil(#G.P_CENTER_POOLS[args._type]/cards_per_page)-1
	end

	S.current_page_text = (S.current_page+1)
	G.OVERLAY_MENU:get_UIE_by_ID('current_page_num'):update_text()

	for i = 1, #S.card_display do
		current_center = current_center + 1
		local center = G.P_CENTER_POOLS[args._type][current_center + (S.current_page*(args.row*args.col))]
		if not center then break end
		local card = Card(S.card_display[i].T.x + S.card_display[i].T.w/args.row, S.card_display[i].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center)
		card.s_stats = true
		card.s_deck = true
		S.card_display[i]:emplace(card)
	end
end