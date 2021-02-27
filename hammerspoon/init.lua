local uiPrefs = {textColor = {0.8,0.8,0.8,0.9},
		fontName = 'Monaco',
		textSize = 12,
		highlightColor = {0,0.5,0.9,0.8},
		backgroundColor = {0.2,0.2,0.2,0.6},
		onlyActiveApplication = false,
		showTitles = true,
		titleBackgroundColor = {0,0,0,0},
		showThumbnails = true,
		thumbnailSize = 128,
		showSelectedThumbnail = false,
		selectedThumbnailSize = 384,
		showSelectedTitle = true, }

switcher = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}, uiPrefs)

hs.hotkey.bind('alt','tab', function()switcher:next()end)
hs.hotkey.bind('alt-shift','tab',function()switcher:previous()end)
