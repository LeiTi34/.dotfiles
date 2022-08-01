import colors as Colors

colors = Colors.get_colors()
themes = {
    'light': {
        'bg_normal': colors['light'],
        'bg_dim': colors['light_dim'],
        'bg_dimmer': colors['light_dimmer'],
        'fg_normal': colors['dark'],
        'fg_dim': colors['dark_dim'],
        'fg_dimmer': colors['dark_dimmer'],
        'fg_comment': colors['light_dimmest'],
        'fg_colored_bg': colors['light'],
        'red_soft': colors['red_light'],
        'red_hard': colors['red_dark'],
        'green_soft': colors['green_light'],
        'green_hard': colors['green_dark'],
        'yellow_soft': colors['yellow_light'],
        'yellow_hard': colors['yellow_dark'],
        'blue_soft': colors['blue_light'],
        'blue_hard': colors['blue_dark'],
        'purple_soft': colors['purple_light'],
        'purple_hard': colors['purple_dark'],
        'teal_soft': colors['teal_light'],
        'teal_hard': colors['teal_dark'],
    },
    'dark': {
        'bg_normal': colors['dark'],
        'bg_dim': colors['dark_dim'],
        'bg_dimmer': colors['dark_dimmer'],
        'fg_normal': colors['light'],
        'fg_dim': colors['light_dim'],
        'fg_dimmer': colors['light_dimmer'],
        'fg_comment': colors['dark_dimmest'],
        'fg_colored_bg': colors['light'],
        'red_soft': colors['red_dark'],
        'red_hard': colors['red_light'],
        'green_soft': colors['green_dark'],
        'green_hard': colors['green_light'],
        'yellow_soft': colors['yellow_dark'],
        'yellow_hard': colors['yellow_light'],
        'blue_soft': colors['blue_dark'],
        'blue_hard': colors['blue_light'],
        'purple_soft': colors['purple_dark'],
        'purple_hard': colors['purple_light'],
        'teal_soft': colors['teal_dark'],
        'teal_hard': colors['teal_light'],
    },
    'darkest': {
        'bg_normal': colors['darkest'],
        'bg_dim': colors['dark'],
        'bg_dimmer': colors['dark_dim'],
        'fg_normal': colors['lightest'],
        'fg_dim': colors['light_dim'],
        'fg_dimmer': colors['light_dimmer'],
        'fg_comment': colors['dark_dimmest'],
        'fg_colored_bg': colors['lightest'],
        'red_soft': colors['red_dark'],
        'red_hard': colors['red_lightest'],
        'green_soft': colors['green_dark'],
        'green_hard': colors['green_lightest'],
        'yellow_soft': colors['yellow_dark'],
        'yellow_hard': colors['yellow_lightest'],
        'blue_soft': colors['blue_dark'],
        'blue_hard': colors['blue_lightest'],
        'purple_soft': colors['purple_dark'],
        'purple_hard': colors['purple_lightest'],
        'teal_soft': colors['teal_dark'],
        'teal_hard': colors['teal_lightest'],
    }
}

def get_theme(theme='darkest'):
    return themes[theme]


    
