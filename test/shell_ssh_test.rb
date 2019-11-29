require "test_helper"

class ShellSSHTest < Minitest::Test
  def test_build_command
    expected = 'ssh -i /path/to/key user@host > /backup.file'
    assert_equal expected, Sometimes::Shell::SSH.build_command(
      '/path/to/key', 'user', 'host', '/backup.file')
  end
end

