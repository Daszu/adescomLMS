{block name="voipaccountinfobox-extra"}
<tr>
    <td>
        <img src="img/money.gif" alt="">
    </td>
    <td class="bold nobr">
        {trans("Tariff:")}
    </td>
    <td {if $voipaccountinfo.tariff && $voipaccountinfo.tariff->getDeleted()}style="color: red;"{/if}>
        {if $voipaccountinfo.tariff}
        {$voipaccountinfo.tariff->getName()}
        {/if}
    </td>
</tr>
<tr>
    <td>
        <img src="img/node.gif" alt="">
    </td>
    <td class="bold nobr">
        {trans("IP Address:")}
    </td>
    <td>
        {if $voipaccountinfo.ip_address !== null && $voipaccountinfo.port !== null}
        {$voipaccountinfo.ip_address}:{$voipaccountinfo.port}
        {else}
        {t}No data{/t}
        {/if}
    </td>
</tr>
<tr>
    <td></td>
    <td class="bold nobr">
        {t}Status:{/t}
    </td>
    <td style="font-size: 2.5em;">
        {if $voipaccountinfo.status == 1}
        <span style="color: green;">&#x25cf;</span>
        {else}
        <span style="color: red;">&#x25cf;</span>
        {/if}
    </td>
</tr>
<tr>
    <td></td>
    <td class="bold nobr">
        {t}Limit:{/t}
    </td>
    <td>
        {if $voipaccountinfo.absolute_limit !== null}
        {$voipaccountinfo.absolute_limit|money_format}
        {else}
        {t}No data{/t}
        {/if}
    </td>
</tr>
<tr>
    <td></td>
    <td class="bold nobr">
        {t}Prepaid:{/t}
    </td>
    <td>
        {if $voipaccountinfo.account_state_type !== null}
        {if $voipaccountinfo.account_state_type}{t}Yes{/t}{else}{t}No{/t}{/if}
        {else}
        {t}No data{/t}
        {/if}
    </td>
</tr>
<tr>
    <td></td>
    <td class="bold nobr">
        {t}Account state:{/t}
    </td>
    <td>
        {if $voipaccountinfo.account_state !== null}
        {$voipaccountinfo.account_state|money_format}
        {else}
        {t}No data{/t}
        {/if}
    </td>
</tr>
{/block}