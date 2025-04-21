return {
  "seblyng/roslyn.nvim",
  build = function()
    vim.cmd("RoslynInstall")
  end,
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "williamboman/mason.nvim",
  },
  config = function()
    local ok, roslyn = pcall(require, "roslyn")
    if not ok then
      vim.notify("Roslyn.nvim not found!", vim.log.levels.ERROR)
      return
    end

    roslyn.setup({
      dotnet_cmd = "dotnet",
      on_attach = function(client, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        map("n", "<leader>.", vim.lsp.buf.code_action, "Code Action")
        map("v", "<leader>rm", vim.lsp.buf.range_code_action, "Extract Method")
      end,
    })
  end,
}

