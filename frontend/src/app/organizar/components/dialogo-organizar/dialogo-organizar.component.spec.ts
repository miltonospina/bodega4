import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DialogoOrganizarComponent } from './dialogo-organizar.component';

describe('DialogoOrganizarComponent', () => {
  let component: DialogoOrganizarComponent;
  let fixture: ComponentFixture<DialogoOrganizarComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DialogoOrganizarComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(DialogoOrganizarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
