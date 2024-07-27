local lovely = require("lovely")
local nativefs = require("nativefs")

-- 'global' variable for current chosen tab
local chosen_tab = 'saturn_features'

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

-- features tab
function G.FUNCS.saturn_features(e)
  G.SETTINGS.paused = true
  chosen_tab = 'saturn_features'

  local ref_table = S.TEMP_SETTINGS.modules
  local _buttons = {
    {label = 'StatTracker', toggle_ref = ref_table.stattrack, button_ref = 'config_stattracker',},
    {label = 'DeckViewer+', toggle_ref = ref_table.deckviewer_plus, button_ref = 'config_deckviewer',},
    {label = 'Challenger+', toggle_ref = ref_table.challenger_plus, button_ref = 'config_challenger',},
  }
  local _tabs = {
    {label = 'Features',},
    {label = 'Preferences', button_ref = 'saturn_preferences',},
    {label = 'Stats', button_ref = 'saturn_stats',},
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

-- preferences tab
function G.FUNCS.saturn_preferences(e)
  G.SETTINGS.paused = true
  chosen_tab = 'saturn_preferences'

  local ref_table = S.TEMP_SETTINGS.modules.preferences
  local _buttons = {
    {label = 'Animation Skip', toggle_ref = ref_table.remove_animations,},
    {label = 'Compact View', toggle_ref = ref_table.compact_view,},
  }
  local _tabs = {
    {label = "Features", button_ref = 'saturn_features'},
    {label = 'Preferences',},
    {label = 'Stats', button_ref = 'saturn_stats',},
  }

  G.FUNCS.overlay_menu({
    definition = s_create_options({
      apply_func = "apply_settings",
      back_func = "options",
      tabs = s_create_tabs(_tabs),
      nodes = s_create_buttons(_buttons),
    })
  })
end

-- stats tab
function G.FUNCS.saturn_stats(e)
  G.SETTINGS.paused = true
  chosen_tab = 'saturn_stats'
  S.current_page = 0
  
  local _buttons = {
    {label = 'General Stats', button_ref = 'view_general', button_label = 'View', remove_enable = true,},
    {label = localize('b_jokers'), button_ref = 'view_jokers', button_label = 'View', remove_enable = true,},
    {label = 'Tarot Cards', button_ref = 'view_tarots', button_label = 'View', remove_enable = true,},
    {label = 'Planet Cards', button_ref = 'view_planets', button_label = 'View', remove_enable = true,},
    {label = 'Spectral Cards', button_ref = 'view_spectrals', button_label = 'View', remove_enable = true,},
  }
  local _tabs = {
    {label = "Features", button_ref = 'saturn_features'},
    {label = 'Preferences', button_ref = 'saturn_preferences'},
    {label = 'Stats',},
  }

  G.FUNCS.overlay_menu({
    definition = s_create_options({
      back_func = "options",
      tabs = s_create_tabs(_tabs),
      nodes = s_create_buttons(_buttons),
    })
  })
end

-- config buttons

-- stat tracker config
function G.FUNCS.config_stattracker(e)
  G.SETTINGS.paused = true

  local ref_table = S.TEMP_SETTINGS.modules.stattrack.features.joker_tracking.groups
  local _buttons = {
    {label = 'Money Generators', toggle_ref = ref_table, ref_value = 'money_generators', remove_enable = true,},
    {label = 'Card Generators', toggle_ref = ref_table, ref_value = 'card_generators', remove_enable = true,},
    {label = '+ Chip Jokers', toggle_ref = ref_table, ref_value = 'chips_plus', remove_enable = true,},
    {label = '+ Mult Jokers', toggle_ref = ref_table, ref_value = 'mult_plus', remove_enable = true,},
    {label = 'x Mult Jokers', toggle_ref = ref_table, ref_value = 'mult_mult', remove_enable = true,},
    {label = 'Miscellaneous', toggle_ref = ref_table, ref_value = 'miscellaneous', remove_enable = true,},
  }

  G.FUNCS.overlay_menu({
    definition = s_create_options({
      apply_func = 'apply_settings',
      back_func = 'saturn_features',
      title = 'Joker Tracking Options',
      nodes = s_create_buttons(_buttons),
    })
  })
end

-- highscore config
function G.FUNCS.config_highscore(e)
  G.SETTINGS.paused = true

  local ref_table = S.TEMP_SETTINGS.modules.highscore.features.highscore_counter.groups
  local _buttons = {
    {label = 'Money Generators', toggle_ref = ref_table, ref_value = 'money_generators', remove_enable = true,},
    {label = 'Card Generators', toggle_ref = ref_table, ref_value = 'card_generators', remove_enable = true,},
    {label = '+ Chip Scaling', toggle_ref = ref_table, ref_value = 'plus_chips_scale', remove_enable = true,},
    {label = '+ Mult Scaling', toggle_ref = ref_table, ref_value = 'plus_mult_scaling', remove_enable = true,},
    {label = 'x Mult Scaling', toggle_ref = ref_table, ref_value = 'x_mult_scaling', remove_enable = true,},
    {label = 'Retriggers', toggle_ref = ref_table, ref_value = 'retriggers', remove_enable = true,},
    {label = 'Activations', toggle_ref = ref_table, ref_value = 'activations', remove_enable = true,},
    {label = 'Miscellaneous', toggle_ref = ref_table, ref_value = 'miscellaneous', remove_enable = true,},
  }

  G.FUNCS.overlay_menu({
    definition = s_create_options({
      apply_func = 'apply_settings',
      back_func = 'saturn_features',
      title = 'Joker Highscore Options',
      nodes = s_create_buttons(_buttons),
    })
  })
end

-- deckviewer config
function G.FUNCS.config_deckviewer(e)
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
function G.FUNCS.config_challenger(e)
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
function G.FUNCS.view_general(e) end

-- joker stats
function G.FUNCS.view_jokers(e)
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
function G.FUNCS.view_tarots(e)
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
function G.FUNCS.view_planets(e)
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
function G.FUNCS.view_spectrals(e)
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

-- individual card stats view buttons

-- specific card stats
function G.FUNCS.card_stats(e)
  G.SETTINGS.paused = true

  G.FUNCS.overlay_menu({
    definition = s_create_options({
      back_func = 'view_'..e.ability.set:lower()..'s',
      title = localize({type = 'name_text', set = e.ability.set, key = e.config.center.key}),
      nodes = s_create_stats_page(e)
    })
  })
end

-- other button callbacks

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

function G.FUNCS.use_consumeables(e)
  G.FUNCS:exit_overlay_menu()
  if G.consumeables and G.consumeables.cards then
    consume_cards(G.consumeables.cards)
  end
end

function consume_cards(cards)
  local area = G.STATE
  local to_consume = {}

  -- First pass: Collect cards to be consumed
  for k, v in pairs(cards) do
    if v:can_use_consumeable() then
      table.insert(to_consume, v)
    end
  end

  -- Second pass: Use the collected cards
  for _, card in ipairs(to_consume) do
    local e = { config = { ref_table = card } }
    -- G.FUNCS.use_card(e)
    if card.area then
      card.area:remove_card(card)
    end

    card:use_consumeable(area)
    draw_card(G.hand, G.play, 1, 'up', true, card, nil, mute)
    for i = 1, #G.jokers.cards do
      G.jokers.cards[i]:calculate_joker({ using_consumeable = true, consumeable = card })
    end
    -- card:remove()
    card:start_dissolve()
  end

end