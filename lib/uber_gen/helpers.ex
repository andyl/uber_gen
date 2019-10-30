defmodule UberGen.Helpers do

  # ----- from Mix.Generate

  def copy_file(ctx) do
    ctx
  end

  def copy_template(ctx) do
    ctx
  end

  def create_directory(ctx) do
    ctx
  end

  def create_file(ctx) do
    ctx
  end

  def embed_template(ctx) do
    ctx
  end

  def embed_text(ctx) do
    ctx
  end

  def overwrite?(ctx) do
    ctx
  end

  # ----- context management

  def assign(ctx, _key, _val) do
    ctx
  end

  # ----- commands

  def mix(ctx, _command) do
    ctx
  end

  def shell(ctx, _command) do
    ctx
  end

  # ----- environment check

  def check_host(ctx) do
    ctx
  end

  # ----- packages

  def mix_dependency(ctx) do
    ctx
  end

  def npm_dependency(ctx) do
    ctx
  end
end
