local L = LibStub("AceLocale-3.0"):NewLocale("EasyFrames", "ruRU")
if not L then return end


L["loaded. Options:"] = "загружен. Настройки:"

L["Opacity"] = "Прозрачность"
L["Opacity of combat texture"] = "Прозрачность текстуры в бою"

L["Main options"] = "Главные настройки"
L["In main options you can set the global options like colored frames, class portraits, etc"] = "В окне главных настроек вы можете установить глобальные настройки фреймов, таких как Раскрасить фреймы здоровья в цвет класса, установить иконку класса в портрет и другие"

L["Percent"] = "Проценты"
L["Current + Max"] = "Текущее + Макс"
L["Current + Max + Percent"] = "Текущее + Макс + Проценты"
L["Current + Percent"] = "Текущее + Проценты"
L["Custom format"] = "Свой формат"

L["HP and MP bars"] = "Фреймы здоровья и маны"

L["Font size"] = "Размер шрифта"
L["Healthbar and manabar font size"] = "Размер шрифта фреймов здоровья и маны"
L["Font family"] = "Шрифт"
L["Healthbar and manabar font family"] = "Шрифт фреймов здоровья и маны"

L["Custom format of HP"] = "Свой формат HP"
L["You can set custom HP format. More information about custom HP format you can read on project site.\n\n" ..
        "Formulas:"] = "Вы можете установить свой формат HP. Больше информации о данном формате HP можно прочитать на сайте проекта.\n\n" ..
        "Формулы:"
L["Use full values of health"] = "Использовать полные значения здоровья"
L["Formula converts the original value to the specified value.\n\n" ..
        "Description: for example formula is '%.fM'.\n" ..
        "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
        "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"] = "Исходные значения преобразуются по заданной формуле.\n\n" ..
            "Описание: возьмем формулу - '%.fM'.\n" ..
            "Первая часть '%.f' это сама формула, вторая часть 'M' это аббревиатура\n\n" ..
            "Пример, значение HP 150550.\n'%.f' преобразует его в '151', а '%.1f' в '150.6'"
L["Value greater than 1000"] = "Значение больше 1000"
L["Value greater than 100 000"] = "Значение больше 100 000"
L["Value greater than 1 000 000"] = "Значение больше 1 000 000"
L["Value greater than 10 000 000"] = "Значение больше 10 000 000"
L["Value greater than 100 000 000"] = "Значение больше 100 000 000"
L["Value greater than 1 000 000 000"] = "Значение больше 1 000 000 000"
L["By default all formulas use divider (for value eq 1000 and more it's 1000, for 1 000 000 and more it's 1 000 000, etc).\n\n" ..
        "If checked formulas will use full values of HP (without divider)"] = "По умолчанию все формулы используют делитель (для значения 1000 и больше он равен 1000, для 1 000 000 и больше он равен 1 000 000 и т.д.).\n\n" ..
            "Если установлено формулы используют полные значения HP (без делителя)"
L["Displayed HP by pattern"] = "Отображение HP по шаблону"
L["You can use patterns:\n\n" ..
        "%CURRENT% - return current health\n" ..
        "%MAX% - return maximum of health\n" ..
        "%PERCENT% - return percent of current/max health\n\n" ..
        "All values are returned from formulas. For set abbreviation use formulas' fields"] = "Вы можете использовать шаблоны:\n\n" ..
            "%CURRENT% - возвращает текущее значение здоровья\n" ..
            "%MAX% - возвращает максимальное значение здоровья\n" ..
            "%PERCENT% - возвращает проценты от текущее/максимальное значение здоровья\n\n" ..
            "Все значения возвращаются с формул. Для установки аббревиатур используйте поля формул"

L["Frames"] = "Фреймы"
L["Setting for unit frames"] = "Настройки фреймов"

L["Class colored healthbars"] = "Раскрасить фреймы здоровья в цвет класса"
L["Healthbar color based on current health. IN DEVELOPMENT..."] = "В РАЗРАБОТКЕ... Цвет фреймов основан на текущем значении здоровья"
L["Frames healthbar color based on his current health"] = "Цвет фреймов основан на текущем значении здоровья"
L["If checked frames becomes class colored"] = "Если установлено фреймы раскрашиваются в цвет класса"
L["Custom buffsize"] = "Собственный размер бафов"
L["Buffs settings (like custom buffsize, highlight dispelled buffs, etc)"] = "Настройки бафов (использовать собственный размер бафов, подсвечивать бафы, которые могут быть рассеяны и другие)"
L["Turn on custom buffsize"] = "Собственный размер бафов"
L["Turn on custom target and focus frames buffsize"] = "Включить собственный размер бафов у цели и фокус фреймов"
L["Buffs"] = "Бафы"
L["Buffsize"] = "Размер бафов"
L["Self buffsize"] = "Размер своих бафов"
L["Buffsize that you create"] = "Размер бафов, которые вы создаете"
L["Highlight dispelled buffs"] = "Подсвечивать бафы, которые могут быть рассеяны"
L["Highlight buffs that can be dispelled from target frame"] = "Подсвечивать бафы у цели, которые могут быть рассеяны"
L["Dispelled buff scale"] = "Размер (scale) бафов (dispelled)"
L["Dispelled buff scale that can be dispelled from target frame"] = "Размер (scale) бафов, которые могут быть рассеяны"
L["Only if player can dispel them"] = "Только если игрок может их рассеять"
L["Highlight dispelled buffs only if player can dispel them"] = "Подсвечивать бафы у цели, которые могут быть рассеяны, только если игрок может их рассеять"

L["Class portraits"] = "Иконка класса в портрете"
L["Replaces the unit-frame portrait with their class icon"] = "Заменяет портрет фрейма иконкой класса"

L["Texture"] = "Текстура"
L["Set the frames bar Texture"] = "Установить текстуру фреймов"

L["Bright frames border"] = "Светлые границы фреймов"
L["You can set frames border bright/dark color. From bright to dark. 0 - dark, 100 - bright"] = "Вы можете установить свет границ фреймов. От светлого к темному. 0 - темные границы, 100 - светлые"

L["Frames colors"] = "Цвета фреймов"
L["In this section you can set the default colors for friendly, enemy and neutral frames"] = "В этом разделе вы можете установить цвета фреймов по умолчанию для дружественных, враждебных или нейтральных целей"
L["Set default friendly healthbar color"] = "Цвет по умолчанию дружественных целей"
L["You can set the default friendly healthbar color for frames"] = "Вы можете установить цвет фреймов по умолчанию дружественных к вам целей"
L["Set default enemy healthbar color"] = "Цвет по умолчанию враждебных целей"
L["You can set the default enemy healthbar color for frames"] = "Вы можете установить цвет фреймов по умолчанию враждебных к вам целей"
L["Set default neutral healthbar color"] = "Цвет по умолчанию нейтральных целей"
L["You can set the default neutral healthbar color for frames"] = "Вы можете установить цвет фреймов по умолчанию нейтральных к вам целей"
L["Reset color to default"] = "Сбросить цвет"

L["Other"] = "Другое"
L["In this section you can set the settings like 'show welcome message' etc"] = "В этом разделе вы можете установить разные настройки не вошедшие в другие разделы (показывать приветственный текст в чате и другие)"
L["Show welcome message"] = "Показывать приветственный текст в чате"
L["Show welcome message when addon is loaded"] = "Показывать приветственный текст в чате когда аддон был загружен"


L["Player"] = "Игрок"
L["In player options you can set scale player frame, healthbar text format, etc"] = "В разделе Игрок вы можете установить размер (scale) фрейма игрока, установить формат HP и другие"
L["Show or hide some elements of frame"] = "Показать или скрыть некоторые элементы фрейма"
L["Show player name"] = "Показывать имя игрока"
L["Player frame scale"] = "Размер фрейма игрока"
L["Scale of player unit frame"] = "Размер (scale) фрейма игрока"
L["Enable hit indicators"] = "Показывать входящий урон и исцеление"
L["Show or hide the damage/heal which you take on your unit frame"] = "Показывать получаемый урон/исцеление на фрейме игрока"
L["Player healthbar text format"] = "Формат HP игрока"
L["Set the player healthbar text format"] = "Установить формат отображения здоровья игрока"
L["Show player specialbar"] = "Показывать фрейм классового ресурса"
L["Show or hide the player specialbar, like Paladin's holy power, Priest's orbs, Monk's harmony or Warlock's soul shards"] = "Показывать фрейм классового ресурса, такие как Энергия Света паладинов, Безумие пристов, Ци монахов, Осколки души чернокнижников и другие"
L["Show player resting icon"] = "Показывать иконку отдыха игрока"
L["Show or hide player resting icon when player is resting (e.g. in the tavern or in the capital)"] = "Показывать иконку отдыха игрока когда он отдыхает (например, в таверне или в столице)"
L["Show player status texture (inside the frame)"] = "Показывать статус текстуру игрока (внутри фрейма)"
L["Show or hide player status texture (blinking glow inside the frame when player is resting or in combat)"] = "Показывать статус текстуру игрока (мигающая рамка внутри фрейма во время отдыха или боя)"
L["Show player combat texture (outside the frame)"] = "Показывать фоновую текстуру игрока (снаружи фрейма)"
L["Show or hide player red background texture (blinking red glow outside the frame in combat)"] = "Показывать красную текстуру в бою (мигающая рамка снаружи фрейма во время боя)"
L["Show player group number"] = "Показывать номер группы"
L["Show or hide player group number when player is in a raid group (over portrait)"] = "Показывать номер группы когда игрок в рейде (над портретом)"
L["Show player role icon"] = "Показывать иконку роли игрока"
L["Show or hide player role icon when player is in a group"] = "Показывать иконку роли когда игрок в группе"


L["Target"] = "Цель"
L["In target options you can set scale target frame, healthbar text format, etc"] = "В разделе Цель вы можете установить размер (scale) фрейма цели, установить формат HP и другие"
L["Target frame scale"] = "Размер фрейма цели"
L["Scale of target unit frame"] = "Размер (scale) фрейма цели"
L["Target healthbar text format"] = "Формат HP цели"
L["Set the target healthbar text format"] = "Установить формат отображения здоровья цели"
L["Show target of target frame"] = "Показывать цель цели"
L["Show target name"] = "Показывать имя цели"
L["Show target combat texture (outside the frame)"] = "Показывать фоновую текстуру цели (снаружи фрейма)"
L["Show or hide target red background texture (blinking red glow outside the frame in combat)"] = "Показывать красную текстуру в бою (мигающая рамка снаружи фрейма во время боя)"
L["Show blizzard's target castbar"] = "Показывать у цели castbar Blizzard"
L["When you change this option you need to reload your UI (because it's Blizzard config variable). \n\nCommand /reload"] = "После установки данной опции вам необходимо перезагрузить UI (т.к. это внутренние настройки Blizzard). \n\nКоманда /reload"


L["Focus"] = "Фокус"
L["In focus options you can set scale focus frame, healthbar text format, etc"] = "В разделе Фокус вы можете установить размер (scale) фокус фрейма, установить формат HP и другие"
L["Focus frame scale"] = "Размер фокус фрейма"
L["Scale of focus unit frame"] = "Размер (scale) фокус фрейма"
L["Focus healthbar text format"] = "Формат HP фокус фрейма"
L["Set the focus healthbar text format"] = "Установить формат отображения здоровья фокус фрейма"
L["Show target of focus frame"] = "Показывать цель фокус фрейма"
L["Show name of focus frame"] = "Показывать имя фокус фрейма"
L["Show focus combat texture (outside the frame)"] = "Показывать фоновую текстуру фокус фрейма (снаружи фрейма)"
L["Show or hide focus red background texture (blinking red glow outside the frame in combat)"] = "Показывать красную текстуру в бою (мигающая рамка снаружи фрейма во время боя)"


L["Pet"] = "Питомец"
L["In pet options you can set scale pet frame, show/hide pet name, enable/disable pet hit indicators, etc"] = "В разделе Питомец вы можете установить размер (scale) фрейма питомца, Показывать имя питомца, включить отображение входящего урона и исцеления питомца и другие"
L["Pet frame scale"] = "Размер фрейма питомца"
L["Scale of pet unit frame"] = "Размер (scale) фрейма питомца"
L["Lock pet frame"] = "Заблокировать фрейм питомца"
L["Lock or unlock pet frame. When unlocked you can move frame using your mouse (draggable)"] = "Заблокировать или разблокировать фрейм питомца. Когда разблокировано фрейм можно передвигать (перетаскивать)"
L["Reset position to default"] = "Сбросить позицию"
L["Show pet name"] = "Показывать имя питомца"
L["Show or hide the damage/heal which your pet take on pet unit frame"] = "Показывать получаемый урон/исцеление на фрейме питомца"
L["Show pet combat texture (inside the frame)"] = "Показывать фоновую текстуру фрейма питомца (внутри фрейма)"
L["Show or hide pet red background texture (blinking red glow inside the frame in combat)"] = "Показывать красную текстуру в бою (мигающая рамка внутри фрейма во время боя)"
L["Show pet combat texture (outside the frame)"] = "Показывать фоновую текстуру фрейма питомца (снаружи фрейма)"
L["Show or hide pet red background texture (blinking red glow outside the frame in combat)"] = "Показывать красную текстуру в бою (мигающая рамка снаружи фрейма во время боя)"

