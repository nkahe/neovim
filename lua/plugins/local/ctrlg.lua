
-- Forked from wsdjeg/ctrlg.nvim to better suit with narrower notifications.
-- https://github.com/wsdjeg/ctrlg.nvim

return {
  display = function()
    local pwd = vim.fn.getcwd()
    local project_name
    if vim.fn.isdirectory('.git') == 1 then
      project_name = string.format('[%s]', vim.fn.fnamemodify(pwd, ':t'))
    else
      project_name = ''
    end

    local file = vim.fn.fnamemodify(vim.fn.expand('%'), ':.')

    local messages = {}

    if #project_name > 0 then
      vim.list_extend(messages, { { project_name, 'Constant' }, { ': ', 'WarningMsg' } }, 1, 2)
    end

    vim.list_extend(
      messages,
      { { 'CWD: ' }, { pwd .. '\n', 'Special' }, { 'File: ' }, { file, 'Directory' } },
      1,
      4
    )
    vim.api.nvim_echo(messages, false, {})
  end,
}
