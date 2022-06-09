from colors import Colors

class Themes():
    def __init__(self):
        self.colors = Colors().colors
        self.themes = {
            'light': {
                'bg_normal': self.colors['light'],
                'bg_dim': self.colors['light_dim'],
                'bg_dimmer': self.colors['light_dimmer'],
                'fg_normal': self.colors['dark'],
                'fg_dim': self.colors['dark_dim'],
                'fg_dimmer': self.colors['dark_dimmer'],
                'fg_comment': self.colors['light_dimmest'],
                'fg_colored_bg': self.colors['light'],
                'red_soft': self.colors['red_light'],
                'red_hard': self.colors['red_dark'],
                'green_soft': self.colors['green_light'],
                'green_hard': self.colors['green_dark'],
                'yellow_soft': self.colors['yellow_light'],
                'yellow_hard': self.colors['yellow_dark'],
                'blue_soft': self.colors['blue_light'],
                'blue_hard': self.colors['blue_dark'],
                'purple_soft': self.colors['purple_light'],
                'purple_hard': self.colors['purple_dark'],
                'teal_soft': self.colors['teal_light'],
                'teal_hard': self.colors['teal_dark'],
            },
            'dark': {
                'bg_normal': self.colors['dark'],
                'bg_dim': self.colors['dark_dim'],
                'bg_dimmer': self.colors['dark_dimmer'],
                'fg_normal': self.colors['light'],
                'fg_dim': self.colors['light_dim'],
                'fg_dimmer': self.colors['light_dimmer'],
                'fg_comment': self.colors['dark_dimmest'],
                'fg_colored_bg': self.colors['light'],
                'red_soft': self.colors['red_dark'],
                'red_hard': self.colors['red_light'],
                'green_soft': self.colors['green_dark'],
                'green_hard': self.colors['green_light'],
                'yellow_soft': self.colors['yellow_dark'],
                'yellow_hard': self.colors['yellow_light'],
                'blue_soft': self.colors['blue_dark'],
                'blue_hard': self.colors['blue_light'],
                'purple_soft': self.colors['purple_dark'],
                'purple_hard': self.colors['purple_light'],
                'teal_soft': self.colors['teal_dark'],
                'teal_hard': self.colors['teal_light'],
            },
            'darkest': {
                'bg_normal': self.colors['darkest'],
                'bg_dim': self.colors['dark'],
                'bg_dimmer': self.colors['dark_dim'],
                'fg_normal': self.colors['lightest'],
                'fg_dim': self.colors['light_dim'],
                'fg_dimmer': self.colors['light_dimmer'],
                'fg_comment': self.colors['dark_dimmest'],
                'fg_colored_bg': self.colors['lightest'],
                'red_soft': self.colors['red_dark'],
                'red_hard': self.colors['red_lightest'],
                'green_soft': self.colors['green_dark'],
                'green_hard': self.colors['green_lightest'],
                'yellow_soft': self.colors['yellow_dark'],
                'yellow_hard': self.colors['yellow_lightest'],
                'blue_soft': self.colors['blue_dark'],
                'blue_hard': self.colors['blue_lightest'],
                'purple_soft': self.colors['purple_dark'],
                'purple_hard': self.colors['purple_lightest'],
                'teal_soft': self.colors['teal_dark'],
                'teal_hard': self.colors['teal_lightest'],
            }
        }
    def get_theme(self, theme):
        return self.themes[theme]


    
