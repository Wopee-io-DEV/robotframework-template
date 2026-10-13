*** Settings ***
Library     Browser


*** Keywords ***
Page Ready
    [Documentation]    Wait until web fonts and images are loaded, so the screenshot shows the finished page.
    Wait For Load State    load
    Evaluate JavaScript    ${None}
    ...    async () => {
    ...        await Promise.all([
    ...            ...Array.from(document.fonts).map((font) => font.load()),
    ...            ...Array.from(document.images).map((img) => img.decode().catch(() => undefined)),
    ...        ]);
    ...    }
