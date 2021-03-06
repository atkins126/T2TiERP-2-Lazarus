{ *******************************************************************************
Title: T2Ti ERP
Description: Janela Cheque Recebido

The MIT License

Copyright: Copyright (C) 2016 T2Ti.COM

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

@author Albert Eije (t2ti.com@gmail.com)
@version 2.0
******************************************************************************* }
unit UFinChequeRecebido;

{$MODE Delphi}

interface

uses
  BrookHTTPClient, BrookFCLHTTPClientBroker, BrookHTTPUtils, BrookUtils, FPJson, ZDataset,
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  ComCtrls, LabeledCtrls, rxdbgrid, rxtoolbar, DBCtrls, StrUtils,
  Math, Constantes, CheckLst, ActnList, ToolWin, db, BufDataset, Biblioteca,
  ULookup, VO, FinChequeRecebidoVO,
  FinChequeRecebidoController;

  type

  TFFinChequeRecebido = class(TFTelaCadastro)
    PanelParcelas: TPanel;
    PanelMestre: TPanel;
    EditCpfCnpj: TLabeledEdit;
    EditValor: TLabeledCalcEdit;
    EditIdContaCaixa: TLabeledCalcEdit;
    EditContaCaixa: TLabeledEdit;
    EditNome: TLabeledEdit;
    EditCodigoBanco: TLabeledEdit;
    EditCodigoAgencia: TLabeledEdit;
    EditConta: TLabeledEdit;
    EditNumero: TLabeledCalcEdit;
    EditDataEmissao: TLabeledDateEdit;
    EditBomPara: TLabeledDateEdit;
    EditDataCompensacao: TLabeledDateEdit;
    GroupBox1: TGroupBox;
    EditCustodiaData: TLabeledDateEdit;
    EditCustodiaTarifa: TLabeledCalcEdit;
    EditCustodiaComissao: TLabeledCalcEdit;
    GroupBox2: TGroupBox;
    EditDescontoData: TLabeledDateEdit;
    EditDescontoTarifa: TLabeledCalcEdit;
    EditDescontoComissao: TLabeledCalcEdit;
    EditValorRecebido: TLabeledCalcEdit;
    procedure FormCreate(Sender: TObject);
    procedure EditIdContaCaixaKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BotaoConsultarClick(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
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
  FFinChequeRecebido: TFFinChequeRecebido;

implementation

uses UDataModule, ContaCaixaVO, ContaCaixaController;
{$R *.lfm}

{$REGION 'Infra'}
procedure TFFinChequeRecebido.BotaoConsultarClick(Sender: TObject);
var
  RetornoConsulta: TZQuery;
  ListaCampos: TStringList;
  i: integer;
begin
  inherited;

  if Sessao.Camadas = 2 then
  begin
    Filtro := MontaFiltro;

    CDSGrid.Close;
    CDSGrid.Open;
    ConfiguraGridFromVO(Grid, ClasseObjetoGridVO);

    ListaCampos  := TStringList.Create;
    RetornoConsulta := TFinChequeRecebidoController.Consulta(Filtro, IntToStr(Pagina));
    RetornoConsulta.Active := True;

    RetornoConsulta.GetFieldNames(ListaCampos);

    RetornoConsulta.First;
    while not RetornoConsulta.EOF do begin
      CDSGrid.Append;
      for i := 0 to ListaCampos.Count - 1 do
      begin
        CDSGrid.FieldByName(ListaCampos[i]).Value := RetornoConsulta.FieldByName(ListaCampos[i]).Value;
      end;
      CDSGrid.Post;
      RetornoConsulta.Next;
    end;
  end;
end;

procedure TFFinChequeRecebido.BotaoSalvarClick(Sender: TObject);
begin
  inherited;
  BotaoConsultarClick(Sender);
end;

procedure TFFinChequeRecebido.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TFinChequeRecebidoVO;
  ObjetoController := TFinChequeRecebidoController.Create;

  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFFinChequeRecebido.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditIdContaCaixa.SetFocus;
  end;
end;

function TFFinChequeRecebido.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditIdContaCaixa.SetFocus;
  end;
end;

function TFFinChequeRecebido.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TFinChequeRecebidoController.Exclui(IdRegistroSelecionado);
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

function TFFinChequeRecebido.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TFinChequeRecebidoVO.Create;

      TFinChequeRecebidoVO(ObjetoVO).IdContaCaixa := EditIdContaCaixa.AsInteger;
      TFinChequeRecebidoVO(ObjetoVO).ContaCaixaNome := EditContaCaixa.Text;
      TFinChequeRecebidoVO(ObjetoVO).CpfCnpj := EditCpfCnpj.Text;
      TFinChequeRecebidoVO(ObjetoVO).Nome := EditNome.Text;
      TFinChequeRecebidoVO(ObjetoVO).CodigoBanco := EditCodigoBanco.Text;
      TFinChequeRecebidoVO(ObjetoVO).CodigoAgencia := EditCodigoAgencia.Text;
      TFinChequeRecebidoVO(ObjetoVO).Conta := EditConta.Text;
      TFinChequeRecebidoVO(ObjetoVO).Numero := EditNumero.AsInteger;
      TFinChequeRecebidoVO(ObjetoVO).DataEmissao := EditDataEmissao.Date;
      TFinChequeRecebidoVO(ObjetoVO).BomPara := EditBomPara.Date;
      TFinChequeRecebidoVO(ObjetoVO).DataCompensacao := EditDataCompensacao.Date;
      TFinChequeRecebidoVO(ObjetoVO).CustodiaData := EditCustodiaData.Date;
      TFinChequeRecebidoVO(ObjetoVO).CustodiaTarifa := EditCustodiaTarifa.Value;
      TFinChequeRecebidoVO(ObjetoVO).CustodiaComissao := EditCustodiaComissao.Value;
      TFinChequeRecebidoVO(ObjetoVO).DescontoData := EditDescontoData.Date;
      TFinChequeRecebidoVO(ObjetoVO).DescontoTarifa := EditDescontoTarifa.Value;
      TFinChequeRecebidoVO(ObjetoVO).DescontoComissao := EditDescontoComissao.Value;
      TFinChequeRecebidoVO(ObjetoVO).Valor := EditValor.Value;
      TFinChequeRecebidoVO(ObjetoVO).ValorRecebido := EditValorRecebido.Value;

      if StatusTela = stInserindo then
      begin
        TFinChequeRecebidoController.Insere(TFinChequeRecebidoVO(ObjetoVO));
      end
      else if StatusTela = stEditando then
      begin
        if TFinChequeRecebidoVO(ObjetoVO).ToJSONString <> StringObjetoOld then
        begin
          TFinChequeRecebidoController.Altera(TFinChequeRecebidoVO(ObjetoVO));
        end
        else
          Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
    except
      Result := False;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Campos Transientes'}
procedure TFFinChequeRecebido.EditIdContaCaixaKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Filtro: String;
  ContaCaixaVO :TContaCaixaVO ;
begin
  if Key = VK_F1 then
  begin
    if EditIdContaCaixa.Value <> 0 then
      Filtro := 'ID = ' + EditIdContaCaixa.Text
    else
      Filtro := 'ID=0';

    try
      EditContaCaixa.Clear;

        ContaCaixaVO := TContaCaixaController.ConsultaObjeto(Filtro);
        if Assigned(ContaCaixaVO) then
      begin
        EditContaCaixa.Text := ContaCaixaVO.Nome;
      end
      else
      begin
        Exit;
      end;
    finally
      EditCpfCnpj.SetFocus;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFFinChequeRecebido.GridParaEdits;
var
  IdCabecalho: String;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    IdCabecalho := IntToStr(IdRegistroSelecionado);
    ObjetoVO := TFinChequeRecebidoController.ConsultaObjeto('ID=' + IdCabecalho);
  end;

  if Assigned(ObjetoVO) then
  begin
    EditIdContaCaixa.AsInteger := TFinChequeRecebidoVO(ObjetoVO).IdContaCaixa;
    EditContaCaixa.Text := TFinChequeRecebidoVO(ObjetoVO).ContaCaixaNome;
    EditCpfCnpj.Text := TFinChequeRecebidoVO(ObjetoVO).CpfCnpj;
    EditNome.Text := TFinChequeRecebidoVO(ObjetoVO).Nome;
    EditCodigoBanco.Text := TFinChequeRecebidoVO(ObjetoVO).CodigoBanco;
    EditCodigoAgencia.Text := TFinChequeRecebidoVO(ObjetoVO).CodigoAgencia;
    EditConta.Text := TFinChequeRecebidoVO(ObjetoVO).Conta;
    EditNumero.AsInteger := TFinChequeRecebidoVO(ObjetoVO).Numero;
    EditDataEmissao.Date := TFinChequeRecebidoVO(ObjetoVO).DataEmissao;
    EditBomPara.Date := TFinChequeRecebidoVO(ObjetoVO).BomPara;
    EditDataCompensacao.Date := TFinChequeRecebidoVO(ObjetoVO).DataCompensacao;
    EditCustodiaData.Date := TFinChequeRecebidoVO(ObjetoVO).CustodiaData;
    EditCustodiaTarifa.Value := TFinChequeRecebidoVO(ObjetoVO).CustodiaTarifa;
    EditCustodiaComissao.Value := TFinChequeRecebidoVO(ObjetoVO).CustodiaComissao;
    EditDescontoData.Date := TFinChequeRecebidoVO(ObjetoVO).DescontoData;
    EditDescontoTarifa.Value := TFinChequeRecebidoVO(ObjetoVO).DescontoTarifa;
    EditDescontoComissao.Value := TFinChequeRecebidoVO(ObjetoVO).DescontoComissao;
    EditValor.Value := TFinChequeRecebidoVO(ObjetoVO).Valor;
    EditValorRecebido.Value := TFinChequeRecebidoVO(ObjetoVO).ValorRecebido;

    // Serializa o objeto para consultar posteriormente se houve alterações
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
end;
{$ENDREGION}

end.

