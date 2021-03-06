{ *******************************************************************************
Title: T2Ti ERP
Description: Janela Cadastro de Parâmetros para o Ponto Eletrônico

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

@author Albert Eije (alberteije@gmail.com)
@version 2.0
******************************************************************************* }
unit UPontoParametro;

{$MODE Delphi}

interface

uses
  BrookHTTPClient, BrookFCLHTTPClientBroker, BrookHTTPUtils, BrookUtils, FPJson, ZDataset,
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  ComCtrls, LabeledCtrls, rxdbgrid, rxtoolbar, DBCtrls, StrUtils,
  Math, Constantes, CheckLst, ActnList, ToolWin, db, BufDataset, Biblioteca,
  ULookup, VO, PontoParametroVO,
  PontoParametroController;

  type

  TFPontoParametro = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditMesAno: TLabeledMaskEdit;
    EditDiaInicialApuracao: TLabeledCalcEdit;
    EditHoraNoturnaInicio: TLabeledMaskEdit;
    EditHoraNoturnaFim: TLabeledMaskEdit;
    EditPeriodoMinimoInterjornada: TLabeledMaskEdit;
    EditPercentualHEDiurna: TLabeledCalcEdit;
    EditPercentualHENoturna: TLabeledCalcEdit;
    EditDuracaoHoraNoturna: TLabeledMaskEdit;
    CheckBoxRepetirParametros: TCheckBox;
    ComboBoxTratamentoHoraMais: TLabeledComboBox;
    ComboBoxTratamentoHoraMenos: TLabeledComboBox;
    procedure FormCreate(Sender: TObject);
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
  FPontoParametro: TFPontoParametro;

implementation

uses UDataModule;

{$R *.lfm}

{$REGION 'Infra'}
procedure TFPontoParametro.BotaoConsultarClick(Sender: TObject);
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
    RetornoConsulta := TPontoParametroController.Consulta(Filtro, IntToStr(Pagina));
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

procedure TFPontoParametro.BotaoSalvarClick(Sender: TObject);
begin
  inherited;
  BotaoConsultarClick(Sender);
end;

procedure TFPontoParametro.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TPontoParametroVO;
  ObjetoController := TPontoParametroController.Create;

  inherited;
  BotaoImprimir.Visible := False;
  MenuImprimir.Visible := False;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFPontoParametro.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    CheckBoxRepetirParametros.Enabled := True;
    EditMesAno.SetFocus;
  end;
end;

function TFPontoParametro.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    CheckBoxRepetirParametros.Enabled := False;
    EditMesAno.SetFocus;
  end;
end;

function TFPontoParametro.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TPontoParametroController.Exclui(IdRegistroSelecionado);
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

function TFPontoParametro.DoSalvar: Boolean;
var
  i: Integer;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TPontoParametroVO.Create;

      TPontoParametroVO(ObjetoVO).IdEmpresa := Sessao.Empresa.Id;
      TPontoParametroVO(ObjetoVO).MesAno := EditMesAno.Text;
      TPontoParametroVO(ObjetoVO).DiaInicialApuracao := EditDiaInicialApuracao.AsInteger;
      TPontoParametroVO(ObjetoVO).HoraNoturnaInicio := EditHoraNoturnaInicio.Text;
      TPontoParametroVO(ObjetoVO).HoraNoturnaFim := EditHoraNoturnaFim.Text;
      TPontoParametroVO(ObjetoVO).PeriodoMinimoInterjornada := EditPeriodoMinimoInterjornada.Text;
      TPontoParametroVO(ObjetoVO).PercentualHeDiurna := EditPercentualHEDiurna.Value;
      TPontoParametroVO(ObjetoVO).PercentualHeNoturna := EditPercentualHENoturna.Value;
      TPontoParametroVO(ObjetoVO).DuracaoHoraNoturna := EditDuracaoHoraNoturna.Text;
      TPontoParametroVO(ObjetoVO).TratamentoHoraMais := IfThen(ComboBoxTratamentoHoraMais.ItemIndex = 0, 'E', 'B');
      TPontoParametroVO(ObjetoVO).TratamentoHoraMenos := IfThen(ComboBoxTratamentoHoraMenos.ItemIndex = 0, 'F', 'B');

      if StatusTela = stInserindo then
      begin
        if CheckBoxRepetirParametros.Enabled then
        begin
          for i := 1 to 12 do
          begin
            TPontoParametroVO(ObjetoVO).MesAno := StringOfChar('0', 2 - Length(IntToStr(i))) + IntToStr(i) + '/' + Copy(EditMesAno.Text, 4, 4);
        TPontoParametroController.Insere(TPontoParametroVO(ObjetoVO));
          end;
        end
        else
        TPontoParametroController.Insere(TPontoParametroVO(ObjetoVO));
      end
      else if StatusTela = stEditando then
      begin
        if TPontoParametroVO(ObjetoVO).ToJSONString <> StringObjetoOld then
        begin
          TPontoParametroController.Altera(TPontoParametroVO(ObjetoVO));
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

{$REGION 'Controle de Grid'}
procedure TFPontoParametro.GridParaEdits;
var
  IdCabecalho: String;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    IdCabecalho := IntToStr(IdRegistroSelecionado);
    ObjetoVO := TPontoParametroController.ConsultaObjeto('ID=' + IdCabecalho);
  end;

  if Assigned(ObjetoVO) then
  begin
    EditMesAno.Text := TPontoParametroVO(ObjetoVO).MesAno;
    EditDiaInicialApuracao.AsInteger := TPontoParametroVO(ObjetoVO).DiaInicialApuracao;
    EditHoraNoturnaInicio.Text := TPontoParametroVO(ObjetoVO).HoraNoturnaInicio;
    EditHoraNoturnaFim.Text := TPontoParametroVO(ObjetoVO).HoraNoturnaFim;
    EditPeriodoMinimoInterjornada.Text := TPontoParametroVO(ObjetoVO).PeriodoMinimoInterjornada;
    EditPercentualHEDiurna.Value := TPontoParametroVO(ObjetoVO).PercentualHeDiurna;
    EditPercentualHENoturna.Value := TPontoParametroVO(ObjetoVO).PercentualHeNoturna;
    EditDuracaoHoraNoturna.Text := TPontoParametroVO(ObjetoVO).DuracaoHoraNoturna;

    case AnsiIndexStr(TPontoParametroVO(ObjetoVO).TratamentoHoraMais, ['E', 'B']) of
      0:
        ComboBoxTratamentoHoraMais.ItemIndex := 0;
      1:
        ComboBoxTratamentoHoraMais.ItemIndex := 1;
    end;

    case AnsiIndexStr(TPontoParametroVO(ObjetoVO).TratamentoHoraMenos, ['F', 'B']) of
      0:
        ComboBoxTratamentoHoraMenos.ItemIndex := 0;
      1:
        ComboBoxTratamentoHoraMenos.ItemIndex := 1;
    end;

    // Serializa o objeto para consultar posteriormente se houve alterações
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
end;
{$ENDREGION}

end.

