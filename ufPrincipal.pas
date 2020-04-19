unit ufPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Phys.Intf, FireDAC.Phys,
  FireDAC.Comp.DataSet,
  FireDAC.Stan.Param, FireDAC.Phys.MySQLDef,
  uDataModule,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Phys.MySQL, FireDAC.Stan.Intf,
  FireDAC.Comp.UI, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys.MSAccDef,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc;

type
  TModo = (modoInclusao, modoAlteracao, modoLeitura);
  TDataModule = class(TDataModule1);

  TLivraria = class(TForm)
    pnlFundo: TPanel;
    pnlAutores: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    pnlA_Operacoes: TPanel;
    btnA_Alterar: TButton;
    btnA_Incluir: TButton;
    btnA_Excluir: TButton;
    edtId_Autores: TEdit;
    edtNome_Autores: TEdit;
    btnA_Anterior: TButton;
    btnA_Proximo: TButton;
    btnVerLivros: TButton;
    pnlA_Confirmar: TPanel;
    btnA_Cancelar: TButton;
    btnA_Salvar: TButton;
    btnAbrirConsulta: TButton;
    DBGrid1: TDBGrid;
    lblModoAutor: TLabel;
    pnlLivros: TPanel;
    btnFecharConsulta: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtId_Livro: TEdit;
    edtNome_Livro: TEdit;
    edtAutor_Livro: TEdit;
    pnlL_Operacoes: TPanel;
    btnL_Excluir: TButton;
    btnL_Alterar: TButton;
    btnL_Incluir: TButton;
    lblModoLivro: TLabel;
    btnProximoLivro: TButton;
    btnAnteriorlivro: TButton;
    DBGrid2: TDBGrid;
    pnlL_Confirmar: TPanel;
    btnL_Salvar: TButton;
    btnL_Cancelar: TButton;

    procedure btnAbrirConsultaClick(Sender: TObject);
    procedure btnA_ProximoClick(Sender: TObject);
    procedure btnA_AnteriorClick(Sender: TObject);
    procedure btnA_AlterarClick(Sender: TObject);
    procedure btnA_IncluirClick(Sender: TObject);
    procedure btnA_ExcluirClick(Sender: TObject);
    procedure btnA_SalvarClick(Sender: TObject);
    procedure btnA_CancelarClick(Sender: TObject);
    procedure btnVerLivrosClick(Sender: TObject);
    procedure btnAnteriorlivroClick(Sender: TObject);
    procedure btnProximoLivroClick(Sender: TObject);
    procedure btnL_AlterarClick(Sender: TObject);
    procedure btnL_IncluirClick(Sender: TObject);
    procedure btnL_CancelarClick(Sender: TObject);
    procedure btnL_SalvarClick(Sender: TObject);
    procedure btnFecharConsultaClick(Sender: TObject);
    procedure btnL_ExcluirClick(Sender: TObject);
  private
    FModo: TModo;
    procedure ConsultarLinhas_Autor;
    procedure ConsultarLinhas_Livro;
    procedure ConexaoBD;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Livraria: TLivraria;

implementation

{$R *.dfm}

procedure TLivraria.ConexaoBD;
begin
  if DataModule1.conexao.Connected = False then
  begin
    DataModule1.conexao.Connected := True;
    ShowMessage('Banco de Dados Conectado.');
  end
  else
  begin
    DataModule1.conexao.Connected := False;
    ShowMessage('Banco de Dados Desconectado.');
  end;
end;

procedure TLivraria.btnL_AlterarClick(Sender: TObject);
begin
  btnVerLivros.Enabled := False;
  btnL_Alterar.Enabled := False;
  btnL_Incluir.Enabled := False;
  btnL_Excluir.Enabled := True;
  pnlL_Confirmar.Enabled := True;
  btnL_Cancelar.Enabled := True;
  btnL_Salvar.Enabled := True;
  edtId_Livro.ReadOnly := True;
  edtNome_Livro.ReadOnly := False;
  edtNome_Livro.SetFocus;
  lblModoLivro.Caption := 'Modo: Alteração';

  edtId_Livro.ReadOnly := True;
  FModo := modoAlteracao;
end;

procedure TLivraria.btnAnteriorlivroClick(Sender: TObject);
begin
  DataModule1.qryLivros.Prior;
  ConsultarLinhas_Livro;
end;

procedure TLivraria.btnA_AlterarClick(Sender: TObject);
begin
  btnA_Cancelar.Enabled := True;
  btnA_Salvar.Enabled := True;
  btnVerLivros.Enabled := False;
  btnA_Alterar.Enabled := False;
  btnA_Incluir.Enabled := False;
  btnA_Excluir.Enabled := True;
  edtId_Autores.ReadOnly := True;
  edtNome_Autores.ReadOnly := False;
  edtNome_Autores.SetFocus;
  lblModoAutor.Caption := 'Modo: Alteração';

  edtId_Autores.ReadOnly := True;
  FModo := modoAlteracao;
end;

procedure TLivraria.btnA_AnteriorClick(Sender: TObject);
begin
  DataModule1.qryAutores.Prior;
  ConsultarLinhas_Autor;
end;

procedure TLivraria.btnA_CancelarClick(Sender: TObject);
begin
  btnA_Cancelar.Enabled := False;
  btnA_Salvar.Enabled := False;
  lblModoAutor.Caption := 'Modo: Leitura';
  ConsultarLinhas_Autor;
  btnVerLivros.Enabled := True;
  btnA_Alterar.Enabled := True;
  btnA_Incluir.Enabled := True;
  btnA_Excluir.Enabled := False;
  edtId_Autores.ReadOnly := True;
  edtNome_Autores.ReadOnly := True;
  FModo := modoLeitura;
end;

procedure TLivraria.btnA_ExcluirClick(Sender: TObject);
begin
  if DataModule1.conexao.ExecSQL('DELETE FROM autores WHERE id_autor=' +
    QuotedStr(edtId_Autores.Text)) > 0 then
  begin
    ShowMessage('Excluido com sucesso!');
    edtId_Autores.ReadOnly := True;
    edtNome_Autores.ReadOnly := True;
    DataModule1.qryAutores.Refresh;
    btnA_Alterar.Enabled := True;
    btnA_Incluir.Enabled := True;
    btnA_Excluir.Enabled := False;
    btnA_Salvar.Enabled := False;
    btnA_Cancelar.Enabled := False;
    btnVerLivros.Enabled := True;
  end;
end;

procedure TLivraria.btnA_IncluirClick(Sender: TObject);
begin
  lblModoAutor.Caption := 'Modo: Inclusão';
  btnA_Cancelar.Enabled := True;
  btnA_Salvar.Enabled := True;
  btnVerLivros.Enabled := False;
  btnA_Alterar.Enabled := False;
  btnA_Incluir.Enabled := False;
  btnA_Excluir.Enabled := False;
  edtId_Autores.ReadOnly := True;
  edtNome_Autores.ReadOnly := False;
  edtNome_Autores.Clear;
  edtNome_Autores.SetFocus;
  FModo := modoInclusao;
end;

procedure TLivraria.btnA_ProximoClick(Sender: TObject);
begin
  DataModule1.qryAutores.Next;
  ConsultarLinhas_Autor;
end;

procedure TLivraria.btnA_SalvarClick(Sender: TObject);
begin
  if FModo = modoLeitura then
    Exit;

  if FModo = modoInclusao then
  begin
    edtId_Autores.ReadOnly := False;
    DataModule1.qryAutores.Append;
    DataModule1.qryAutores.FieldByName('nome_autor').Value :=
      edtNome_Autores.Text;
  end
  else
  begin
    DataModule1.qryAutores.Edit;
  end;
  btnVerLivros.Enabled := True;
  btnA_Cancelar.Enabled := False;
  btnA_Salvar.Enabled := False;
  DataModule1.qryAutores.FieldByName('nome_autor').Value :=
  edtNome_Autores.Text;
  DataModule1.qryAutores.FieldByName('hora_log').Value := (Time);
  DataModule1.qryAutores.FieldByName('data_log').Value := (Date);
  DataModule1.qryAutores.Post;
  btnA_Alterar.Enabled := True;
  btnA_Incluir.Enabled := True;
  edtId_Autores.ReadOnly := True;
  edtNome_Autores.ReadOnly := True;
  FModo := modoLeitura;
  lblModoAutor.Caption := 'Modo: Leitura';
end;

procedure TLivraria.btnFecharConsultaClick(Sender: TObject);
begin
  DataModule1.conexao.Connected := False;
  DataModule1.qryAutores.Active := False;
  pnlAutores.Enabled := False;
  pnlAutores.Visible := False;

  DataModule1.qryLivros.Active := False;
  pnlLivros.Enabled := False;
  pnlLivros.Visible := False;
  btnFecharConsulta.Enabled := False;
  btnAbrirConsulta.Enabled := True;

end;

procedure TLivraria.btnL_IncluirClick(Sender: TObject);
begin
  lblModoLivro.Caption := 'Modo: Inclusão';
  //pnlL_Confirmar.Enabled := True;
  //pnlL_Operacoes.Enabled := False;
  btnVerLivros.Enabled := False;
  btnL_Alterar.Enabled := False;
  btnL_Incluir.Enabled := False;
  btnL_Excluir.Enabled := False;
  btnL_Cancelar.Enabled := True;
  btnL_Salvar.Enabled := True;
  edtId_Livro.ReadOnly := True;
  edtNome_Livro.ReadOnly := False;
  edtNome_Livro.Clear;
  edtNome_Livro.SetFocus;
  if edtAutor_Livro.Text = '' then
  begin
    edtAutor_Livro.ReadOnly := False;
  end else
  begin
  edtAutor_Livro.ReadOnly := True;
  FModo := modoInclusao;
  end;
end;

procedure TLivraria.btnProximoLivroClick(Sender: TObject);
begin
  DataModule1.qryLivros.Next;
  ConsultarLinhas_Livro;
end;

procedure TLivraria.btnL_SalvarClick(Sender: TObject);
begin
  if FModo = modoLeitura then
    Exit;

  if FModo = modoInclusao then
  begin
    edtId_Livro.ReadOnly := False;
    DataModule1.qryLivros.Append;
    DataModule1.qryLivros.FieldByName('nome_livro').Value :=
      edtNome_Livro.Text;
    DataModule1.qryLivros.FieldByName('autor_livro').Value :=
      edtAutor_Livro.Text;
  end
  else
  begin
    DataModule1.qryLivros.Edit;
  end;
  DataModule1.qryLivros.FieldByName('nome_livro').Value :=
    edtNome_Livro.Text;
  DataModule1.qryLivros.FieldByName('autor_livro').Value :=
    edtAutor_Livro.Text;
  btnL_Salvar.Enabled := False;
  DataModule1.qryLivros.Post;
  btnL_Alterar.Enabled := True;
  btnL_Incluir.Enabled := True;
  btnL_Excluir.Enabled := False;
  btnL_Cancelar.Enabled := False;
  edtId_Livro.ReadOnly := True;
  edtNome_Livro.ReadOnly := True;
  FModo := modoLeitura;
  lblModoLivro.Caption := 'Modo: Leitura';
end;

procedure TLivraria.ConsultarLinhas_Livro;
begin
  edtId_Livro.Text := DataModule1.qryLivros.FieldByName('id_livro').AsString;
  edtNome_Livro.Text := DataModule1.qryLivros.FieldByName
    ('nome_livro').AsString;
  edtAutor_Livro.Text := DataModule1.qryLivros.FieldByName
    ('autor_livro').AsString;
end;



procedure TLivraria.btnVerLivrosClick(Sender: TObject);
begin
  pnlLivros.Enabled := True;
  DataModule1.qryLivros.Active := Active;
  DataModule1.qryLivros.SQL.Text :=
    ('SELECT id_livro, nome_livro, autor_livro FROM livros WHERE autor_livro ='
    + edtId_Autores.Text + '');

  try
    DataModule1.qryLivros.Open;
  except
    on E: Exception do
      raise Exception.Create('Falha ao abrir a consulta de Livros!' +
        E.Message);
  end;
  pnlLivros.Enabled := True;
  pnlLivros.Visible := True;
  DataModule1.qryLivros.FetchAll;
  DataModule1.qryLivros.First;
  ConsultarLinhas_Livro;
  //pnlL_Confirmar.Enabled := False;
  //pnlL_Operacoes.Enabled := True;
  btnL_Salvar.Enabled := False;
  btnL_Cancelar.Enabled := False;
  edtId_Livro.ReadOnly := True;
  edtNome_Livro.ReadOnly := True;
  edtAutor_Livro.ReadOnly := True;
  DataModule1.qryLivros.FindKey([edtId_Autores.Text]);

    DataModule1.qryLivros.Open;

  end;

  procedure TLivraria.btnL_CancelarClick(Sender: TObject);
begin
  lblModoLivro.Caption := 'Modo: Leitura';
  ConsultarLinhas_Livro;
  btnVerLivros.Enabled := True;
  btnL_Alterar.Enabled := True;
  btnL_Incluir.Enabled := True;
  btnL_Excluir.Enabled := False;
  btnL_Cancelar.Enabled := False;
  btnL_Salvar.Enabled := False;
  //pnlL_Confirmar.Enabled := False;
  //pnlL_Operacoes.Enabled := True;
  edtId_Livro.ReadOnly := True;
  edtNome_Livro.ReadOnly := True;
  FModo := modoLeitura;
end;

procedure TLivraria.btnL_ExcluirClick(Sender: TObject);
begin
if DataModule1.conexao.ExecSQL('DELETE FROM livros WHERE id_livro=' +
    QuotedStr(edtId_Livro.Text)) > 0 then
  begin
    ShowMessage('Excluido com sucesso!');
    //pnlA_Confirmar.Enabled := False;
    //pnlA_Operacoes.Enabled := True;
    edtId_Livro.ReadOnly := True;
    edtNome_Livro.ReadOnly := True;
    edtAutor_Livro.ReadOnly := True;
    DataModule1.qryLivros.Refresh;
    btnL_Alterar.Enabled := True;
    btnL_Incluir.Enabled := True;
    btnL_Excluir.Enabled := False;
    btnL_Salvar.Enabled := False;
    btnL_Cancelar.Enabled := False;
  end;
end;

procedure TLivraria.ConsultarLinhas_Autor;
  begin
    edtId_Autores.Text := DataModule1.qryAutores.FieldByName('id_autor')
    .AsString; edtNome_Autores.Text := DataModule1.qryAutores.FieldByName
    ('nome_autor').AsString;
  end;

procedure TLivraria.btnAbrirConsultaClick(Sender: TObject);
 begin
  if btnFecharConsulta.Enabled = False then
    btnFecharConsulta.Enabled := True;
 btnA_Cancelar.Enabled := False;
 btnA_Salvar.Enabled := False;
 ConexaoBD;
 DataModule1.qryAutores.Active := Active;
 DataModule1.qryAutores.SQL.Text :=
  'SELECT id_autor, nome_autor, hora_log, data_log FROM autores';
 try
  DataModule1.qryAutores.Open;
 except on E: Exception do raise Exception.Create
    ('Falha ao abrir a consulta de Autores!' + E.Message); end;
 pnlAutores.Enabled := True;
 pnlAutores.Visible := True;
 DataModule1.qryAutores.FetchAll;
 DataModule1.qryAutores.First;
 ConsultarLinhas_Autor;

 //pnlA_Confirmar.Enabled := False;
 //pnlA_Operacoes.Enabled := True;
 edtId_Autores.ReadOnly := True;
 edtNome_Autores.ReadOnly := True;
 btnAbrirConsulta.Enabled := False;
 end;
end.
