{ *******************************************************************************
Title: T2Ti ERP
Description: Janela Cadastro de AtividadeForCli

The MIT License

Copyright: Copyright (C) 2015 T2Ti.COM

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

The author may be contacted at:
t2ti.com@gmail.com</p>

@author T2Ti
@version 2.0
******************************************************************************* }
unit UAtividadeForCli;

{$MODE Delphi}

interface

uses
  BrookHTTPClient, BrookFCLHTTPClientBroker, BrookHTTPUtils, BrookUtils, FPJson,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids,
  DBGrids, ComCtrls, Tipos, Constantes, LabeledCtrls, rxdbgrid,
  AtividadeForCliVO, Biblioteca;

type

  { TFAtividadeForCli }

  TFAtividadeForCli = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditNome: TLabeledEdit;
    EditDescricao: TLabeledEdit;
    PageControl: TPageControl;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FAtividadeForCli: TFAtividadeForCli;

implementation

{$R *.lfm}

{$REGION 'Infra'}
procedure TFAtividadeForCli.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TAtividadeForCliVO;
  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFAtividadeForCli.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditNome.SetFocus;
  end;
end;

function TFAtividadeForCli.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditNome.SetFocus;
  end;
end;

function TFAtividadeForCli.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := ProcessRequest(BrookHttpRequest(Sessao.URL + NomeTabelaBanco + '/' + IntToStr(IdRegistroSelecionado), rmDelete ));
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    BotaoConsultar.Click;
end;

function TFAtividadeForCli.DoSalvar: Boolean;
var
  ObjetoJson: TJSONObject;
begin
  try
    DecimalSeparator := '.';

    Result := inherited DoSalvar;

    if Result then
    begin
      try
        if not Assigned(ObjetoVO) then
          ObjetoVO := TAtividadeForCliVO.Create;

        TAtividadeForCliVO(ObjetoVO).Nome := EditNome.Text;
        TAtividadeForCliVO(ObjetoVO).Descricao := EditDescricao.Text;

        if StatusTela = stInserindo then
        begin
          ObjetoJson := TAtividadeForCliVO(ObjetoVO).ToJSON;
          ProcessRequest(BrookHttpRequest(ObjetoJson, Sessao.URL + NomeTabelaBanco));
          ObjetoJson := Nil;
        end
        else if StatusTela = stEditando then
        begin
          if TAtividadeForCliVO(ObjetoVO).ToJSONString <> StringObjetoOld then
          begin
            ObjetoJson := TAtividadeForCliVO(ObjetoVO).ToJSON;
            ProcessRequest(BrookHttpRequest(ObjetoJson, Sessao.URL + NomeTabelaBanco + '/' + IntToStr(TAtividadeForCliVO(ObjetoVO).Id), rmPut ));
            ObjetoJson := Nil;
          end
          else
            Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
        end;
      except
        Result := False;
      end;
    end;
  finally
    DecimalSeparator := ',';
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFAtividadeForCli.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := TAtividadeForCliVO.Create;
    ConsultarVO(IntToStr(IdRegistroSelecionado), ObjetoVO);
  end;

  if Assigned(ObjetoVO) then
  begin
    EditNome.Text := TAtividadeForCliVO(ObjetoVO).Nome;
    EditDescricao.Text := TAtividadeForCliVO(ObjetoVO).Descricao;

    // Serializa o objeto para consultar posteriormente se houve alterações
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
end;
{$ENDREGION}

end.
