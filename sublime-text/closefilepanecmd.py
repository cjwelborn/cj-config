import sublime_plugin


class CloseFilePaneCommand(sublime_plugin.WindowCommand):
    """ Close the file and then close the pane it was in. """
    def run(self):
        self.window.run_command('close_file')
        views = self.window.views_in_group(
            self.window.active_group()
        )
        if not views:
            # Last file was closed, close the pane.
            self.window.run_command('close_pane')
